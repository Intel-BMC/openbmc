/* Copyright 2018 Intel
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
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <boost/asio/buffers_iterator.hpp>
#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_service.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/asio/posix/stream_descriptor.hpp>
#include <boost/asio/read_until.hpp>
#include <boost/asio/streambuf.hpp>
#include <boost/container/flat_set.hpp>
#include <cassert>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <memory>
#include <optional>
#include <phosphor-logging/log.hpp>
#include <sdbusplus/asio/object_server.hpp>
#include <sdbusplus/bus.hpp>
#include <sdbusplus/bus/match.hpp>
#include <sdbusplus/message.hpp>
#include <sdbusplus/timer.hpp>
#include <vector>
#include <xyz/openbmc_project/State/Watchdog/server.hpp>

void handleResponse(const boost::system::error_code &err,
                    std::size_t bytes_transferred);

static int mailboxDevFd = -1;

static boost::asio::io_service io;
static auto conn = std::make_shared<sdbusplus::asio::connection>(io);
boost::asio::ip::tcp::socket mailBoxDevSocket(io);
boost::asio::deadline_timer pollTimer(io);
boost::asio::posix::stream_descriptor inputDevice(io);

// mailbox registre data[0:0] for FRB2 enable bit
boost::asio::streambuf readBuf(1);
std::string dataRead;

// FRB2 watchdog timeout is 6 minutes
static constexpr unsigned int frb2TimerIntervalMs = 360 * 1000;

// mailbox device polling time interval is 2 seconds
static constexpr unsigned int pollMs = 2000;

static constexpr unsigned int frb2Started = 1;
static constexpr unsigned int frb2Stopped = 0;

// FRB2 status
static uint8_t frb2Status = frb2Stopped;

static constexpr const char *mailboxDevName = "/dev/aspeed-mbox";

static constexpr const char frb2Bus[] = "xyz.openbmc_project.FRB2";
static constexpr const char frb2Obj[] = "/xyz/openbmc_project/FRB2";
static constexpr const char frb2Intf[] = "xyz.openbmc_project.FRB2";

static constexpr char powerBus[] = "xyz.openbmc_project.Chassis.Control.Power";
static constexpr char powerPath[] =
    "/xyz/openbmc_project/Chassis/Control/Power0";
static constexpr char powerIntf[] = "xyz.openbmc_project.Chassis.Control.Power";

static constexpr char wdBus[] = "xyz.openbmc_project.Watchdog";
static constexpr char wdPath[] = "/xyz/openbmc_project/watchdog/host0";
static constexpr char wdIntf[] = "xyz.openbmc_project.State.Watchdog";
static constexpr char propIntf[] = "org.freedesktop.DBus.Properties";

typedef boost::asio::buffers_iterator<boost::asio::const_buffers_1> iterator;

// check if FRB2 bit is 0x1
std::pair<iterator, bool> matchFRB2(iterator begin, iterator end)
{
    unsigned char ch = 0;
    iterator i = begin;

    while (i != end)
    {
        ch = static_cast<unsigned char>(*i);
        if (ch & 0x1)
        {
            return std::make_pair(i, true);
        }
        i++;
    }

    return std::make_pair(i, false);
}

static void startRead()
{
    boost::asio::async_read_until(inputDevice, readBuf, matchFRB2,
                                  [&](const boost::system::error_code &ec,
                                      std::size_t bytes_transferred) {
                                      handleResponse(ec, bytes_transferred);
                                  });
}

template <typename T> void setProperty(const std::string &key, const T &val)
{
    phosphor::logging::log<phosphor::logging::level::DEBUG>(
        "setProperty", phosphor::logging::entry("KEY=%s", key.c_str()));

    try
    {
        conn->async_method_call(
            [](const boost::system::error_code &err) {
                if (err)
                {
                    phosphor::logging::log<phosphor::logging::level::ERR>(
                        "async_method_call error!",
                        phosphor::logging::entry(
                            "ERROR=%s",
                            boost::system::system_error(err).what()));
                }
            },
            wdBus, wdPath, propIntf, "Set", wdIntf, key, std::variant<T>(val));
    }
    catch (sdbusplus::exception::SdBusError &e)
    {
        phosphor::logging::log<phosphor::logging::level::ERR>(
            "Dbus error!", phosphor::logging::entry("ERROR=%s", e.what()));
    }
}
void handleResponse(const boost::system::error_code &err,
                    std::size_t bytes_transferred)
{
    std::istream responseStream(&readBuf);
    std::string response;
    int n = 0;
    uint64_t interval = frb2TimerIntervalMs;

    std::getline(responseStream, response);
    responseStream.clear();

    if (err == boost::system::errc::bad_file_descriptor)
    {

        phosphor::logging::log<phosphor::logging::level::DEBUG>(
            "bad file descriptor");
        return; // we're being destroyed
    }

    if (!err)
    {
        // FRB2 is set by BIOS
        if (frb2Stopped == frb2Status)
        {
            // start FRB2 watchdog
            frb2Status = frb2Started;
            phosphor::logging::log<phosphor::logging::level::DEBUG>(
                "FRB2 enable, start FRB2 watchdog");
            setProperty(
                "ExpireAction",
                std::string(
                    "xyz.openbmc_project.State.Watchdog.Action.HardReset"));
            setProperty("Interval", interval);
            setProperty("TimeRemaining", interval);
            setProperty("Initialized", true);
            setProperty("Enabled", true);
        }
    }
    else if (err == boost::asio::error::misc_errors::not_found)
    {
        // FRB2 is clear, stop FRB2 watchdog if it is started
        if (frb2Started == frb2Status)
        {
            frb2Status = frb2Stopped;
            phosphor::logging::log<phosphor::logging::level::DEBUG>(
                "FRB2 is unset, stop FRB2 watchdog");
            setProperty("Enabled", false);
        }
    }
    else
    {
        phosphor::logging::log<phosphor::logging::level::ERR>(
            "handleResponse error!",
            phosphor::logging::entry("ERROR=%s",
                                     boost::system::system_error(err).what()));
    }

    pollTimer.expires_from_now(boost::posix_time::milliseconds(pollMs));
    pollTimer.async_wait(
        [](const boost::system::error_code &ec) { startRead(); });
}

int main(int argc, char **argv)
{
    phosphor::logging::log<phosphor::logging::level::DEBUG>(
        "Monitor FRB2 signal");

    sdbusplus::bus::match_t biosPostSignal(
        static_cast<sdbusplus::bus::bus &>(*conn),
        sdbusplus::bus::match::rules::type::signal() +
            sdbusplus::bus::match::rules::member("PostCompleted") +
            sdbusplus::bus::match::rules::path(powerPath) +
            sdbusplus::bus::match::rules::interface(powerIntf),
        [](sdbusplus::message::message &msg) {
            uint8_t value = 0;
            ssize_t rc = 0;
            phosphor::logging::log<phosphor::logging::level::INFO>(
                "BIOS post completed signal");
            // stop FRB2 and clean mailbox
            value = 0;
            rc = ::pwrite(mailboxDevFd, &value, 1, 0);
            if (rc != 1)
            {
                phosphor::logging::log<phosphor::logging::level::ERR>(
                    "mailbox write error!");
            }
            setProperty("Enabled", false);
            frb2Status = frb2Stopped;
            return;
        });

    conn->request_name(frb2Bus);

    auto server = sdbusplus::asio::object_server(conn);

    std::shared_ptr<sdbusplus::asio::dbus_interface> frb2Iface =
        server.add_interface(frb2Obj, frb2Intf);

    frb2Iface->register_property("frb2Status", frb2Status);

    frb2Iface->initialize();

    mailboxDevFd = ::open(mailboxDevName, O_RDWR | O_CLOEXEC);
    if (mailboxDevFd < 0)
    {
        phosphor::logging::log<phosphor::logging::level::ERR>(
            "mailbox device open fail!");
        return -1;
    }

    inputDevice.assign(mailboxDevFd);

    startRead();

    io.run();

    ::close(mailboxDevFd);

    return 0;
}
