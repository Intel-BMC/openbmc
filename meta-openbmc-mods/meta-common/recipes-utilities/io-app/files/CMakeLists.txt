cmake_minimum_required(VERSION 2.8.10 FATAL_ERROR)
project(io-app C)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
add_executable(io io-app.c)
install (TARGETS io DESTINATION bin)

