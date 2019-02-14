cmake_minimum_required(VERSION 2.8.10 FATAL_ERROR)
project(lpc-cmds C)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
add_executable(lpc_cmds lpc_cmds.c)
install (TARGETS lpc_cmds DESTINATION bin)

