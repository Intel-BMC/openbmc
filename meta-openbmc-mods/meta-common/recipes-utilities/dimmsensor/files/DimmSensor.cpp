#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <cassert>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <memory>
#include <vector>
#include <linux/aspeed_peci_ioctl.h>

#define PECI_DIMM_TEMP_REG 0x150
#define DIMM_DEFAULT_VALUE 0x55

class DimmConfig {
 public:
  uint8_t chanId, bus, device, function, dimmnum;
};

#define MAX_BUFFER_SIZE 32

// TODO get this from config
auto GetDimmConfig(uint8_t dimm) {
  uint8_t chan = dimm / 2;
  assert(chan < 6);

  auto ret = std::make_unique<DimmConfig>();

  ret->chanId = chan;
  ret->dimmnum = 2;
  ret->bus = 2;
  switch (chan) {
    case 0:
      ret->device = 10;
      ret->function = 2;
      break;
    case 1:
      ret->device = 10;
      ret->function = 6;
      break;
    case 2:
      ret->device = 11;
      ret->function = 2;
      break;
    case 3:
      ret->device = 12;
      ret->function = 2;
      break;
    case 4:
      ret->device = 12;
      ret->function = 6;
      break;
    case 5:
      ret->device = 13;
      ret->function = 2;
      break;
    default:
      assert(0);
      break;
  }

  return ret;
}

// returns read vector on success, empty vector on failure
auto peci_config_local(uint8_t u8target, uint8_t u8bus, uint8_t u8device,
                       uint8_t u8fcn, uint16_t u16reg, uint8_t u8readlen) {
  auto msg = std::make_unique<peci_xfer_msg>();
  uint32_t u32Address;
  int fd;
  std::vector<uint8_t> ret;

  u32Address = u16reg;
  u32Address |= u8fcn << 12;
  u32Address |= u8device << 15;
  u32Address |= u8bus << 20;

  msg->client_addr = u8target;
  msg->tx_len = RDPCICFGLOCAL_WRITE_LEN;
  msg->rx_len = RDPCICFGLOCAL_READ_LEN_BASE + u8readlen;

  msg->tx_buf[0] = RDPCICFGLOCAL_PECI_CMD;
  msg->tx_buf[2] = u32Address & 0xFF;
  msg->tx_buf[3] = (u32Address >> 8) & 0xFF;
  msg->tx_buf[4] = (u32Address >> 16) & 0xFF;

  fd = open("/dev/peci", O_RDWR | O_CLOEXEC);
  if (fd >= 0) {
    int success = ioctl(fd, PECI_IOC_XFER, msg.get());
    if (success == 0) {
      if (DEV_PECI_CC_SUCCESS == msg->rx_buf[0]) {
        ret.resize(RDPCICFGLOCAL_READ_LEN_BASE + u8readlen - 1);
        memcpy(ret.data(), &(msg->rx_buf[1]), ret.size());
      }
    }
    close(fd);
  }
  return ret;
}

int main(int argc, char** argv) {
  if (argc != 3) {
    std::cout << argv[0] << " requires 2 arguments: CPUNum, DimmNum.\n";
    return -1;
  }
  uint8_t cpunum = atoi(argv[1]);
  if (cpunum > 3) {
    std::cout << cpunum << " greater than cpu max of 3.\n";
    return -1;
  }
  uint8_t dimmnum = atoi(argv[2]);
  if (dimmnum > 11) {
    std::cout << dimmnum << " greater than dimm max of 11.\n";
    return -1;
  }

  auto dimm_config = GetDimmConfig(dimmnum);

  uint8_t dimmSelect = dimmnum % 2;  // dimm 0 or 1 for each config

  auto val = peci_config_local(PECI_BASE_ADDR + cpunum, dimm_config->bus,
                               dimm_config->device, dimm_config->function,
                               PECI_DIMM_TEMP_REG + dimmSelect * 4, 4);

  if (!val.size()) {
    std::cout << "Peci Error\n";
    return -1;
  }

  // TODO dimm offsets needed?

  if (val[0] == 0)
    std::cout << "Dimm " << unsigned(dimmnum) << " CPU " << unsigned(cpunum)
              << " not populated.\n";
  else if(val[0] == DIMM_DEFAULT_VALUE)
    std::cout << "Dimm " << unsigned(dimmnum) << " CPU " << unsigned(cpunum)
              << " in illegal state.\n";
  else
    std::cout << unsigned(val[0]) << " degrees C.\n";
}
