/* Copyright 2019 Intel
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <fcntl.h>
#include <linux/input.h>

#include <boost/asio/io_service.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <chrono>
#include <iostream>
#include <phosphor-logging/log.hpp>
#include <sdbusplus/asio/object_server.hpp>

static constexpr uint32_t defaultBeepFrequence = 2000;
static constexpr uint32_t defaultBeepDurationMs = 300;
// Duration between two beeps
static constexpr uint32_t defaultInterBeepDurationMs = 300;
// Duration between two 4-bit digitals
static constexpr uint32_t defaultInterDigitBeepDurationMs = 800;
// Duration between two patterns
static constexpr uint32_t defaultPostBeepDurationMs = 1000;

static constexpr uint8_t offBeepState = 0;
static constexpr uint8_t onBeepState = 1;
// finish 1 bit beep
static constexpr uint8_t interBeepState = 2;
// finish 4 bits beep
static constexpr uint8_t interDigitBeepState = 3;
// finish all bits beep
static constexpr uint8_t postBeepState = 4;

static const std::vector<uint32_t> beepDelayTable = {
    0, defaultBeepDurationMs, defaultInterBeepDurationMs,
    defaultInterDigitBeepDurationMs, defaultPostBeepDurationMs};

static constexpr uint32_t bpBitCount = 4;
static constexpr uint32_t bpShiftCount = 32;
static constexpr uint32_t bpMask = 0xf0000000;

// beep code priority
static constexpr uint8_t beepOff = 0;
static constexpr uint8_t beepVRWatchdogTimeout = 1;
static constexpr uint8_t beepPSUFailure = 2;
static constexpr uint8_t beepCPUMIssing = 3;
static constexpr uint8_t beepCPUCatError = 4;
static constexpr uint8_t beepCPUErr2 = 5;
static constexpr uint8_t beepVoltageMismatch = 6;
static constexpr uint8_t beepCPUConfigError = 7;
static constexpr uint8_t beepPowerFail = 8;
static constexpr uint8_t beepPowerGoodTimeOut = 9;
static constexpr uint8_t beepMax = 10;

// priority, abbrev name map
static const std::map<uint8_t, std::string> beepCodeNameList = {
    {beepVRWatchdogTimeout, "VRWatchdogTimeout"},
    {beepPSUFailure, "PSUFailure"},
    {beepCPUMIssing, "CPUMissing"},
    {beepCPUCatError, "CPUCatError"},
    {beepCPUErr2, "CPUErr2"},
    {beepVoltageMismatch, "VoltageMismatch"},
    {beepCPUConfigError, "CPUConfigError"},
    {beepPowerFail, "PowerFail"},
    {beepPowerGoodTimeOut, "PowerGoodTimeOut"},
};

// priority, code pattern map
static const std::map<uint8_t, std::string> beepCodePatternList = {
    {beepVRWatchdogTimeout, "1-5-1-2"}, {beepPSUFailure, "1-5-1-4"},
    {beepCPUMIssing, "1-5-2-1"},        {beepCPUCatError, "1-5-2-2"},
    {beepCPUErr2, "1-5-2-3"},           {beepVoltageMismatch, "1-5-2-4"},
    {beepCPUConfigError, "1-5-2-5"},    {beepPowerFail, "1-5-4-2"},
    {beepPowerGoodTimeOut, "1-5-4-4"},
};

static const std::vector<uint32_t> beepCodeTable = {
    0, 0x1512, 0x1514, 0x1521, 0x1522, 0x1523, 0x1524, 0x1525, 0x1542, 0x1544};

static constexpr char bpDevName[] = "/dev/input/event0";
static constexpr char bpBusName[] = "xyz.openbmc_project.BeepCode";
static constexpr char bpObjName[] = "/xyz/openbmc_project/BeepCode";
static constexpr char bpIntfName[] = "xyz.openbmc_project.BeepCode";
static constexpr char bpMethodName[] = "Beep";

static std::shared_ptr<sdbusplus::asio::dbus_interface> bpIface;
static boost::asio::io_service io;
static auto conn = std::make_shared<sdbusplus::asio::connection>(io);

class Beeper
{
  public:
    Beeper(boost::asio::io_service& io)
    {
        timer = std::make_unique<boost::asio::steady_timer>(io);
        fdBeepDev = -1;
        currentCount = 0;
        currentBeepCode = 0;
        currentMask = bpMask;
        currentShift = bpShiftCount;
        currentState = offBeepState;
        timerRunning = false;
    }

    ~Beeper()
    {
    }

    void beep(const uint8_t& beepPriority)
    {
        if (timerRunning)
        {
            pendingList.push_back(beepPriority);
            pendingList.sort(std::greater<uint8_t>());
            return;
        }

        performBeep(beepPriority);
    }

  private:
    void performBeep(const uint8_t& beepPriority)
    {
        currentBeepCode = beepCodeTable[beepPriority];
        currentCount = 0;
        currentMask = bpMask;
        currentShift = bpShiftCount;
        getCurrentCount();
        startBeep(defaultBeepFrequence);
        currentState = onBeepState;
        currentCount--;
        timerRunning = true;
        startBeepTimer();
    }

    void startBeepTimer()
    {
        timer->expires_after(
            std::chrono::milliseconds(beepDelayTable[currentState]));
        timer->async_wait([this](const boost::system::error_code& ec) {
            // timer timeout
            switch (currentState)
            {
                case onBeepState:
                    stopBeep();
                    if (currentCount == 0)
                    {
                        // finished the current 4-bit
                        if (currentBeepCode == 0)
                        {
                            // finished all bits
                            currentState = postBeepState;
                        }
                        else
                        {
                            // start next 4-bit
                            currentState = interDigitBeepState;
                            getCurrentCount();
                            currentCount--;
                        }
                    }
                    else
                    {
                        // still in 4-bit processing
                        currentCount--;
                        currentState = interBeepState;
                    }
                    startBeepTimer();
                    break;

                case interBeepState:
                case interDigitBeepState:
                    startBeep(defaultBeepFrequence);
                    currentState = onBeepState;
                    startBeepTimer();
                    break;
                case postBeepState:
                    if (pendingList.size() != 0)
                    {
                        // continue the next new beepcode
                        uint8_t beepPriority = pendingList.front();
                        pendingList.pop_front();
                        performBeep(beepPriority);
                    }
                    else
                    {
                        timerRunning = false;
                    }
                    break;

                default:
                    std::cerr << "Incorrect beepState: "
                              << static_cast<unsigned int>(currentState)
                              << std::endl;
                    break;
            }
        });
    }

    void startBeep(uint32_t freq)
    {
        if (fdBeepDev != -1)
        {
            std::cerr << "beep device is opening already!" << std::endl;
            ::close(fdBeepDev);
            fdBeepDev = -1;
        }

        if ((fdBeepDev = ::open(bpDevName, O_RDWR | O_CLOEXEC)) < 0)
        {
            phosphor::logging::log<phosphor::logging::level::ERR>(
                "Failed to open input device");
            return;
        }

        struct input_event event;
        event.type = EV_SND;
        event.code = SND_TONE;
        event.value = freq;

        if (::write(fdBeepDev, &event, sizeof(struct input_event)) !=
            sizeof(struct input_event))
        {
            phosphor::logging::log<phosphor::logging::level::ERR>(
                "Failed to write a tone sound event");
            ::close(fdBeepDev);
            fdBeepDev = -1;
            return;
        }
        return;
    }

    void stopBeep()
    {
        if (fdBeepDev == -1)
        {
            std::cerr << "beep device is closed!" << std::endl;
            return;
        }

        ::close(fdBeepDev);
        fdBeepDev = -1;
    }

    // Split the beep code based on bpBitCount, for example 0x1544,
    // currentCount=1, 5, 4, 4
    void getCurrentCount()
    {
        while (currentCount == 0)
        {
            currentCount = currentMask & currentBeepCode;
            currentShift -= bpBitCount;
            currentCount >>= currentShift;
            currentBeepCode = currentBeepCode & ~currentMask;
            currentMask >>= bpBitCount;
            if (currentMask == 0)
            {
                break;
            }
        }
    }

    int fdBeepDev;
    bool timerRunning;
    uint32_t currentCount;
    uint32_t currentBeepCode;
    uint32_t currentMask;
    uint32_t currentShift;
    uint8_t currentState;
    std::unique_ptr<boost::asio::steady_timer> timer;
    std::list<uint8_t> pendingList;
};

static Beeper beeper(io);

// dbus method
static void beep(const uint8_t& beepPriority)
{
    if ((beepPriority >= beepMax) || (beepPriority == beepOff))
    {
        std::cerr << "Incorrect input: "
                  << static_cast<unsigned int>(beepPriority) << std::endl;
        return;
    }

    beeper.beep(beepPriority);

    return;
}

int main(int argc, char** argv)
{
    phosphor::logging::log<phosphor::logging::level::INFO>(
        "Starting BeepCode service");

    conn->request_name(bpBusName);
    sdbusplus::asio::object_server server =
        sdbusplus::asio::object_server(conn);
    bpIface = server.add_interface(bpObjName, bpIntfName);

    bpIface->register_property("BeepCodeNameList", beepCodeNameList,
                               sdbusplus::asio::PropertyPermission::readOnly);
    bpIface->register_property("BeepCodePatternList", beepCodePatternList,
                               sdbusplus::asio::PropertyPermission::readOnly);
    bpIface->register_method(bpMethodName, beep);
    bpIface->initialize();

    io.run();
    return 0;
}
