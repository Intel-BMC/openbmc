cmake_minimum_required(VERSION 2.8.10 FATAL_ERROR)
project(beeper-test CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(beeper-test beeper-test.cpp)
install(TARGETS beeper-test DESTINATION bin)

