cmake_minimum_required(VERSION 2.8.10 FATAL_ERROR)
project(mkfru CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(mkfru mkfru.cpp)
install(TARGETS mkfru DESTINATION bin)

