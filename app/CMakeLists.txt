#
# cmake
#
cmake_minimum_required(VERSION 3.0)

# load AVR toolchain
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/avr_toolchain.cmake")

# configure MCU
set(AVR_MCU "atmega328p")
set(AVRDUDE_MCU "m328p")
set(AVR_FCPU 8000000)

# configure programmer
set(AVRDUDE_PROGRAMMER "avrisp")
set(AVRDUDE_BAUDRATE 19200)

# Project configuration
project(AVRFlashingTest
    VERSION 0.1.0
    DESCRIPTION "AVR microcontroller flashing example using cmake and arduino-cli"
    LANGUAGES C CXX
)
add_subdirectory(src)
