cmake_minimum_required(VERSION 3.20)
project(minivr CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(minivr src/main.cpp)

# 让 MSVC 按 UTF-8 读源码，避免中文注释触发 C4819
if (MSVC)
    target_compile_options(minivr PRIVATE /utf-8)
endif()
