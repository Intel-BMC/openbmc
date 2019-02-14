cmake_minimum_required(VERSION 2.8.10 FATAL_ERROR)
project(dimmsensor CXX)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(dimmsensor DimmSensor.cpp)
install (TARGETS dimmsensor DESTINATION bin)

