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

#include <time.h>

#include <boost/asio/io_service.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <chrono>
#include <filesystem>
#include <iostream>
#include <phosphor-logging/log.hpp>
#include <sdbusplus/asio/object_server.hpp>
extern "C" {
#include <i2c/smbus.h>
#include <linux/i2c-dev.h>
}

static constexpr uint32_t syncIntervalNormalMS = 60000;
static constexpr uint32_t syncIntervalFastMS = (syncIntervalNormalMS / 2);
static constexpr uint32_t syncIntervalBootMS = 5000;

static uint32_t syncIntervalMS = syncIntervalNormalMS;

// will update bmc time if the time difference beyond this value
static constexpr uint8_t timeDiffAllowedSecond = 1;
static uint8_t pchDevI2cBusNo = 0;
static uint8_t pchDevI2cSlaveAddr = 0;
static bool getPCHI2cAddrFlag = false;
static constexpr const char* clockFile = "/var/lib/systemd/timesync/clock";
static inline uint8_t bcd2Decimal(uint8_t hex)
{
    uint8_t dec = ((hex & 0xF0) >> 4) * 10 + (hex & 0x0F);
    return dec;
}

class I2CFile
{
  private:
    int fd = -1;

  public:
    I2CFile(const int& i2cBus, const int& slaveAddr, const int& flags)
    {
        std::string i2cDev = "/dev/i2c-" + std::to_string(i2cBus);

        fd = open(i2cDev.c_str(), flags);
        if (fd < 0)
        {
            throw std::runtime_error("Unable to open i2c device.");
        }

        if (ioctl(fd, I2C_SLAVE_FORCE, slaveAddr) < 0)
        {
            close(fd);
            fd = -1;
            throw std::runtime_error("Unable to set i2c slave address.");
        }
    }

    uint8_t i2cReadByteData(const uint8_t& offset)
    {
        int ret = i2c_smbus_read_byte_data(fd, offset);

        if (ret < 0)
        {
            throw std::runtime_error("i2c read failed");
        }
        return static_cast<uint8_t>(ret);
    }

    ~I2CFile()
    {
        if (!(fd < 0))
        {
            close(fd);
        }
    }
};

static void getPCHI2cAddr(std::shared_ptr<sdbusplus::asio::connection>& conn,
                          const std::string& service, const std::string& object,
                          const std::string& interface)
{
    conn->async_method_call(
        [](boost::system::error_code ec,
           const std::vector<
               std::pair<std::string, std::variant<std::string, uint64_t>>>&
               propertiesList) {
            if (ec)
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "DBUS response error: cannot get I2c address of PCH timer",
                    phosphor::logging::entry("ECVALUE=%x", ec.value()),
                    phosphor::logging::entry("ECMESSAGE=%s",
                                             ec.message().c_str()));
                return;
            }
            const uint64_t* i2cBusNoValue = nullptr;
            const uint64_t* i2cSlaveAddrValue = nullptr;
            for (const auto& property : propertiesList)
            {

                if (property.first == "PchSmbusSlaveI2cBus")
                {
                    i2cBusNoValue = std::get_if<uint64_t>(&property.second);
                }
                if (property.first == "PchSmbusSlaveI2cAddress")
                {
                    i2cSlaveAddrValue = std::get_if<uint64_t>(&property.second);
                }
            }
            if ((i2cBusNoValue != nullptr) && (i2cSlaveAddrValue != nullptr))
            {
                pchDevI2cBusNo = static_cast<uint8_t>(*i2cBusNoValue);
                pchDevI2cSlaveAddr = static_cast<uint8_t>(*i2cSlaveAddrValue);
                getPCHI2cAddrFlag = true;
            }
        },
        service, object, "org.freedesktop.DBus.Properties", "GetAll",
        interface);
}

static void
    getPCHTimerConfiguration(std::shared_ptr<sdbusplus::asio::connection>& conn)
{
    conn->async_method_call(
        [&conn](
            boost::system::error_code ec,
            const std::vector<std::pair<
                std::string,
                std::vector<std::pair<std::string, std::vector<std::string>>>>>&
                subtree) {
            if (ec)
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "DBUS response error:cannot get PCH configuration",
                    phosphor::logging::entry("ECVALUE=%x", ec.value()),
                    phosphor::logging::entry("ECMESSAGE=%s",
                                             ec.message().c_str()));
                return;
            }
            if (subtree.empty())
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "subtree empty");
                return;
            }
            getPCHI2cAddr(conn, subtree[0].second[0].first, subtree[0].first,
                          "xyz.openbmc_project.Configuration.PchSmbusSlave");
            return;
        },
        "xyz.openbmc_project.ObjectMapper",
        "/xyz/openbmc_project/object_mapper",
        "xyz.openbmc_project.ObjectMapper", "GetSubTree",
        "/xyz/openbmc_project/", 0,
        std::array<const char*, 1>{
            "xyz.openbmc_project.Configuration.PchSmbusSlave"});

    return;
}

class PCHSync
{
  private:
    bool getPCHDate(uint8_t& year, uint8_t& month, uint8_t& day, uint8_t& hour,
                    uint8_t& minute, uint8_t& second)
    {
        try
        {
            constexpr uint8_t pchDevRegRTCYear = 0x0f;
            constexpr uint8_t pchDevRegRTCMonth = 0x0e;
            constexpr uint8_t pchDevRegRTCDay = 0x0d;
            constexpr uint8_t pchDevRegRTCHour = 0x0b;
            constexpr uint8_t pchDevRegRTCMinute = 0x0a;
            constexpr uint8_t pchDevRegRTCSecond = 0x09;
            I2CFile pchDev(pchDevI2cBusNo, pchDevI2cSlaveAddr,
                           O_RDWR | O_CLOEXEC);
            year = pchDev.i2cReadByteData(pchDevRegRTCYear);
            year = bcd2Decimal(year);
            if (year > 99)
            {
                return false;
            }

            month = pchDev.i2cReadByteData(pchDevRegRTCMonth);
            month = bcd2Decimal(month);
            if ((month < 1) || (month > 12))
            {
                return false;
            }

            day = pchDev.i2cReadByteData(pchDevRegRTCDay);
            day = bcd2Decimal(day);
            if ((day < 1) || (day > 31))
            {
                return false;
            }

            hour = pchDev.i2cReadByteData(pchDevRegRTCHour);
            hour = bcd2Decimal(hour);
            if (hour >= 24)
            {
                return false;
            }

            minute = pchDev.i2cReadByteData(pchDevRegRTCMinute);
            minute = bcd2Decimal(minute);
            if (minute >= 60)
            {
                return false;
            }

            second = pchDev.i2cReadByteData(pchDevRegRTCSecond);
            second = bcd2Decimal(second);
            if (second >= 60)
            {
                return false;
            }
        }
        catch (const std::exception& e)
        {
            return false;
        }

        return true;
    }

    bool getSystemTime(time_t& timeSeconds)
    {
        struct timespec sTime = {0};
        int ret = 0;

        ret = clock_gettime(CLOCK_REALTIME, &sTime);

        if (ret != 0)
        {
            return false;
        }
        timeSeconds = sTime.tv_sec;
        return true;
    }

    bool updateClockFileTimestamp()
    {
        if (!std::filesystem::exists(clockFile))
        {
            phosphor::logging::log<phosphor::logging::level::WARNING>(
                "The systemd timestamp synchronization file doesn't exist: ",
                phosphor::logging::entry("PATHNAME=%s", clockFile));
            return false;
        }
        int rc = utimensat(AT_FDCWD, clockFile, nullptr, 0);
        if (rc)
        {
            phosphor::logging::log<phosphor::logging::level::ERR>(
                "utimensat systemd timestamp synchronization file fail: ",
                phosphor::logging::entry("PATHNAME=%s", clockFile),
                phosphor::logging::entry("ERRCODE=%x", errno));
            return false;
        }
        return true;
    }
    bool setSystemTime(uint32_t timeSeconds)
    {
        struct timespec sTime = {0};
        int ret = 0;

        sTime.tv_sec = timeSeconds;
        sTime.tv_nsec = 0;

        ret = clock_settime(CLOCK_REALTIME, &sTime);

        return (ret == 0);
    }

    bool updateBMCTime()
    {
        int ret = 0;
        time_t BMCTimeSeconds = 0;
        time_t PCHTimeSeconds = 0;
        struct tm tm = {0};

        // get PCH and system time

        if (!getPCHDate(year, month, day, hour, minute, second))
        {
            return false;
        };
        if (!getSystemTime(BMCTimeSeconds))
        {
            return false;
        }
        // fix error when year is set to 2000-2009.
        std::string dateString =
            std::to_string(2000 + year) + "-" + std::to_string(month) + "-" +
            std::to_string(day) + " " + std::to_string(hour) + ":" +
            std::to_string(minute) + ":" + std::to_string(second);

        strptime(dateString.c_str(), "%Y-%m-%d %H:%M:%S", &tm);

        PCHTimeSeconds = mktime(&tm);
        if (PCHTimeSeconds == -1)
        {
            return false;
        }

        if (std::abs(PCHTimeSeconds - BMCTimeSeconds) > timeDiffAllowedSecond)
        {
            if (!setSystemTime(PCHTimeSeconds))
            {
                return false;
            }
            phosphor::logging::log<phosphor::logging::level::INFO>(
                "Update BMC time to: ",
                phosphor::logging::entry("TIME=%s", dateString.c_str()));
        }

        // During the boot time, systemd-timesyncd.service checks
        // "/var/lib/systemd/timesync/clock" and updates the system time with
        // the timestamp of the file
        if (!updateClockFileTimestamp())
        {
            return false;
        }

        return true;
    }

    void startSyncTimer(std::shared_ptr<sdbusplus::asio::connection>& conn)
    {
        // retry 10 times (10 * 5s = 50s ) to get the pch timer
        // configuration.
        static uint8_t retrytimes = 10;
        if (!getPCHI2cAddrFlag)
        {
            if (retrytimes == 0)
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "Get pch timer configuration fail");
                return;
            }
            syncIntervalMS = syncIntervalBootMS;
            getPCHTimerConfiguration(conn);
            retrytimes--;
        }
        else
        {
            if (updateBMCTime())
            {
                syncIntervalMS = syncIntervalNormalMS;
            }
            else
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "Update BMC time Fail");
                syncIntervalMS = syncIntervalFastMS;
            }
        }

        syncTimer->expires_after(std::chrono::milliseconds(syncIntervalMS));
        syncTimer->async_wait(
            [this, &conn](const boost::system::error_code& ec) {
                if (ec)
                {
                    phosphor::logging::log<phosphor::logging::level::ERR>(
                        "Timer cancelled",
                        phosphor::logging::entry("ECVALUE=%x", ec.value()),
                        phosphor::logging::entry("ECMESSAGE=%s",
                                                 ec.message().c_str()));
                    return;
                }
                startSyncTimer(conn);
            });
    }

    std::unique_ptr<boost::asio::steady_timer> syncTimer;
    uint8_t year, month, day, hour, minute, second;

  public:
    PCHSync(boost::asio::io_service& io,
            std::shared_ptr<sdbusplus::asio::connection>& conn)
    {
        syncTimer = std::make_unique<boost::asio::steady_timer>(io);
        startSyncTimer(conn);
    }

    ~PCHSync() = default;
};

int main(int argc, char** argv)
{
    boost::asio::io_service io;
    std::shared_ptr<sdbusplus::asio::connection> conn =
        std::make_shared<sdbusplus::asio::connection>(io);
    sdbusplus::asio::object_server server =
        sdbusplus::asio::object_server(conn);
    PCHSync pchSyncer(io, conn);

    phosphor::logging::log<phosphor::logging::level::INFO>(
        "Starting PCH time sync service");

    io.run();
    return 0;
}
