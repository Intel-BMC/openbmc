cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

add_definitions(-DMCTP_LOG_STDERR)
add_definitions(-DMCTP_HAVE_FILEIO)
add_definitions(-DMCTP_HAVE_STDIO)
add_definitions(-DMCTP_DEFAULT_ALLOC)

add_library(
  libmctp STATIC alloc.c core.c log.c libmctp.h serial.c smbus.c crc32c.c)

target_include_directories(libmctp
                           PUBLIC
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                           $<INSTALL_INTERFACE:include/libmctp)

enable_testing()

add_executable(test_eid tests/test_eid.c tests/test-utils.c)
target_link_libraries(test_eid libmctp)

add_executable(test_seq tests/test_seq.c tests/test-utils.c)
target_link_libraries(test_seq libmctp)

install(TARGETS libmctp DESTINATION lib)
install(
  FILES libmctp.h libmctp-smbus.h libmctp-serial.h crc32c.h DESTINATION include)

