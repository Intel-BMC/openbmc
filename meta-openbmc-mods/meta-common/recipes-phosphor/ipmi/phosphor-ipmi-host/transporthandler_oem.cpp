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

#include "dcmihandler.hpp"

#include <cstdint>
#include <ipmid/api-types.hpp>
#include <ipmid/api.hpp>
#include <ipmid/message.hpp>
#include <ipmid/message/types.hpp>
#include <ipmid/utils.hpp>
#include <vector>

enum class oemLanParam : uint8_t
{
    intelHostnameConfig = 0xc7,
};

constexpr size_t IpmiHostnameLen = 16;
constexpr uint8_t CurrentRevision = 0x11; // Current rev per IPMI Spec 2.0

constexpr ipmi::Cc ccParamNotSupported = 0x80;
constexpr ipmi::Cc ccUnprintable = 0x90;

namespace ipmi::transport
{

constexpr auto validHostnameChars =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX"
    "YZ0123456789-";
constexpr int lanOemHostnameLength = 64;

RspType<> setLanOem(uint8_t channel, uint8_t parameter, message::Payload& req)
{
    std::vector<uint8_t> dataBytes;
    switch (static_cast<oemLanParam>(parameter))
    {
        case oemLanParam::intelHostnameConfig:
        {
            static std::array<uint8_t, lanOemHostnameLength> blockData;
            uint8_t block = 0;
            uint8_t complete = 0;
            if ((req.unpack(block, complete, dataBytes) != 0) ||
                (!req.fullyUnpacked()))
            {
                return responseReqDataLenInvalid();
            }

            size_t numDataBytes = req.size() - 4;
            if ((numDataBytes > IpmiHostnameLen) ||
                (!complete && (numDataBytes < IpmiHostnameLen)))
            {
                return responseReqDataLenInvalid();
            }

            if (!((block > 0) && (block < 5)) ||
                ((complete != 0) && (complete != 1)))
            {
                return responseInvalidFieldRequest();
            }

            if (block == 1)
            {
                blockData.fill(0);
            }

            std::copy(dataBytes.begin(), dataBytes.end(),
                      blockData.data() + ((block - 1) * IpmiHostnameLen));
            if (complete)
            {
                blockData[lanOemHostnameLength - 1] = 0;
                // check hostname, and write it
                std::string newHostname(
                    reinterpret_cast<char*>(blockData.data()),
                    lanOemHostnameLength);
                size_t firstNull = newHostname.find_first_of('\0');
                if (newHostname.find_first_not_of(validHostnameChars) !=
                    firstNull)
                {
                    return response(ccUnprintable);
                }
                std::shared_ptr<sdbusplus::asio::connection> busp = getSdBus();
                ipmi::setDbusProperty(*busp, ::dcmi::networkServiceName,
                                      ::dcmi::networkConfigObj,
                                      ::dcmi::networkConfigIntf,
                                      ::dcmi::hostNameProp, newHostname);
            }
            return responseSuccess();
        }
        default:
            return response(ccParamNotSupported);
    }
    return response(ccParamNotSupported);
}

RspType<message::Payload> getLanOem(uint8_t channel, uint8_t parameter,
                                    uint8_t set, uint8_t block)
{
    message::Payload message;
    message.pack(CurrentRevision);
    oemLanParam param = static_cast<oemLanParam>(parameter);
    switch (param)
    {
        case oemLanParam::intelHostnameConfig:
        {
            if (set != 0)
            {
                return responseInvalidFieldRequest();
            }
            if ((block < 1) || (block > 4))
            {
                return responseInvalidFieldRequest();
            }
            std::shared_ptr<sdbusplus::asio::connection> busp = getSdBus();
            auto service = ipmi::getService(*busp, ::dcmi::networkConfigIntf,
                                            ::dcmi::networkConfigObj);
            auto value = ipmi::getDbusProperty(
                *busp, service, ::dcmi::networkConfigObj,
                ::dcmi::networkConfigIntf, ::dcmi::hostNameProp);
            std::string hostname = std::get<std::string>(value);
            std::array<char, IpmiHostnameLen> buf = {0};
            size_t head = (block - 1) * IpmiHostnameLen;
            if (head < hostname.size())
            {
                size_t numToCopy = hostname.size() - head;
                numToCopy = std::min(IpmiHostnameLen, numToCopy);
                hostname.copy(buf.data(), numToCopy, head);
            }
            message.pack(buf);
            return responseSuccess(std::move(message));
        }
    }
    return response(ccParamNotSupported);
}
} // namespace ipmi::transport
