/*
// Copyright (c) 2019 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Abstract:   default FRU generation
//
*/

#include <fstream>
#include <iostream>
#include <iterator>
#include <numeric>
#include <string>
#include <vector>

constexpr uint8_t fillChar = '.';
constexpr uint8_t eof = 0xc1;
const std::string intel = "Intel Corporation";

// round up to nearest block size (power of 2)
constexpr size_t blockRound(size_t len, size_t blk)
{
    return ((len) + (((blk) - ((len) & ((blk)-1))) & ((blk)-1)));
}

uint8_t mklen(uint8_t len)
{
    return static_cast<uint8_t>((0x3 << 6) | len);
}

struct FruEntry
{
    static constexpr size_t fruBlockSize = 8; // type, length, checksum
    static constexpr size_t fixedBytes = 3;   // type, length, checksum
    FruEntry() = delete;
    FruEntry(const std::vector<uint8_t>& contents)
    {
        constexpr size_t verOffset = 0;
        constexpr size_t lenOffset = 1;
        value.resize(blockRound(fixedBytes + contents.size(), fruBlockSize));
        value[verOffset] = 1;
        value[lenOffset] = blocks();
        std::copy(contents.begin(), contents.end(), value.begin() + 2);
        addChecksum();
    }

    void addChecksum()
    {
        int sum = std::accumulate(value.begin(), value.end(), 0);
        value.back() = static_cast<uint8_t>(256 - sum & 0xff);
    }

    uint8_t blocks() const
    {
        return static_cast<uint8_t>(value.size() / 8);
    }

    std::vector<uint8_t> value;
};

size_t fillDots(std::vector<uint8_t>::iterator start, size_t count)
{
    *start++ = mklen(count); // prefix with (0xc0 | count)
    auto end = start + count++;
    std::fill(start, end, '.');
    return count;
}

size_t fillStr(std::vector<uint8_t>::iterator start, const std::string& str)
{
    size_t count = str.size();
    *start++ = mklen(count++); // prefix with (0xc0 | count)
    std::copy(str.begin(), str.end(), start);
    return count;
}

std::vector<uint8_t> genChassisContents()
{
    constexpr size_t pnSize = 18;
    constexpr size_t snSize = 18;
    constexpr size_t amSize = 31;
    constexpr size_t headerSize = 1;
    constexpr size_t contentSize = headerSize + 1 + pnSize + 1 + snSize + 1 +
                                   amSize + 1 + amSize + sizeof(eof);
    std::vector<uint8_t> data(contentSize);
    size_t offset = 0;
    // chassis type (main server chassis)
    data[offset++] = 0x17;
    // chassis part number
    offset += fillDots(data.begin() + offset, pnSize);
    // chassis serial number
    offset += fillDots(data.begin() + offset, snSize);
    // info am1
    offset += fillDots(data.begin() + offset, amSize);
    // info am2
    offset += fillDots(data.begin() + offset, amSize);
    data[offset] = eof;

    return data;
}

std::vector<uint8_t> genBoardContents(const std::string& name)
{
    constexpr size_t headerSize = 4;
    constexpr size_t snSize = 12;
    constexpr size_t pnSize = 10;
    const std::string version = "FRU Ver 0.01";
    size_t contentSize = headerSize + 1 + name.size() + 1 + intel.size() + 1 +
                         snSize + 1 + pnSize + 1 + version.size() + sizeof(eof);
    std::vector<uint8_t> data(contentSize);
    size_t offset = 0;
    // chassis type (main server chassis)
    data[offset++] = 0; // language code
    data[offset++] = 0; // mfg date/time
    data[offset++] = 0; // mfg date/time
    data[offset++] = 0; // mfg date/time
    // manufacturer name
    offset += fillStr(data.begin() + offset, intel);
    // product name
    offset += fillStr(data.begin() + offset, name);
    // board sn
    offset += fillDots(data.begin() + offset, snSize);
    // board pn
    offset += fillDots(data.begin() + offset, pnSize);
    // fru version string
    offset += fillStr(data.begin() + offset, version);
    data[offset] = eof;

    return data;
}

std::vector<uint8_t> genProductContents(const std::string& name)
{
    constexpr size_t headerSize = 1;
    constexpr size_t pnSize = 10;
    constexpr size_t pvSize = 20;
    constexpr size_t snSize = 12;
    constexpr size_t atSize = 20;
    constexpr size_t idSize = 0;
    const std::string version = "FRU Ver 0.01";
    size_t contentSize = headerSize + 1 + intel.size() + 1 + name.size() + 1 +
                         pnSize + 1 + pvSize + 1 + snSize + 1 + atSize + 1 +
                         idSize + sizeof(eof);
    std::vector<uint8_t> data(contentSize);
    size_t offset = 0;
    // chassis type (main server chassis)
    data[offset++] = 0; // language code
    // manufacturer name
    offset += fillStr(data.begin() + offset, intel);
    // product name
    offset += fillStr(data.begin() + offset, name);
    // product part number
    offset += fillDots(data.begin() + offset, pnSize);
    // product version
    offset += fillDots(data.begin() + offset, pvSize);
    // product serial number
    offset += fillDots(data.begin() + offset, snSize);
    // product asset tag
    offset += fillDots(data.begin() + offset, atSize);
    // empty fru file id
    offset += fillDots(data.begin() + offset, idSize);
    data[offset] = eof;

    return data;
}

int createFru(const std::string& name)
{
    std::vector<uint8_t> internal{1, 0, 0, 0, 0, 0, 0, 1}; // fixed data
    FruEntry chassis(genChassisContents());
    FruEntry board(genBoardContents(name));
    FruEntry product(genProductContents(name));
    uint8_t offset = 1; // room for header's offset
    FruEntry header({
        offset += 1, // internal size
        offset += chassis.blocks(),
        offset += board.blocks(),
    });
    std::string filename = name + ".fru.bin";
    std::ofstream output(filename);
    std::ostream_iterator<uint8_t> outputIter(output);
    std::copy(header.value.begin(), header.value.end(), outputIter);
    std::copy(internal.begin(), internal.end(), outputIter);
    std::copy(chassis.value.begin(), chassis.value.end(), outputIter);
    std::copy(board.value.begin(), board.value.end(), outputIter);
    std::copy(product.value.begin(), product.value.end(), outputIter);
    constexpr size_t minFruSize = 0x1ff;
    size_t fruSize = header.value.size() + internal.size() +
                     chassis.value.size() + board.value.size() +
                     product.value.size();
    if (fruSize < minFruSize)
    {
        std::vector<uint8_t> padding(minFruSize - fruSize);
        std::copy(padding.begin(), padding.end(), outputIter);
    }
    output.close();
    return 0;
}

int main(int argc, const char* argv[])
{
    if (argc != 2)
    {
        std::cerr << "Usage: " << argv[0] << " <'Product Name'>\n";
        return 1;
    }
    return createFru(argv[1]);
}
