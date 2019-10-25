#ifndef CRC32C_H
#define CRC32C_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdlib.h>

uint32_t crc32c(uint8_t *buf, int len);

#ifdef __cplusplus
}
#endif
#endif /* CRC32C_H */
