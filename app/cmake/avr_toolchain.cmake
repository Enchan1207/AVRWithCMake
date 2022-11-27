#
# CMake AVR toolchain with arduino-cli
#
# 2022 @Enchan1207
#
cmake_minimum_required(VERSION 3.0)

# #
# # toolchain commands configuration
# #

# specify tools directory of arduino-cli
set(ARDUINOCLI_ROOT "")

if(DEFINED ENV{ARDUINOCLI_ROOT})
    set(ARDUINOCLI_ROOT "$ENV{ARDUINOCLI_ROOT}")
else()
    if(APPLE)
        set(ARDUINOCLI_ROOT "~/Library/Arduino15")
    elseif(UNIX)
        set(ARDUINOCLI_ROOT "~/.arduino15")
    else()
        set(ARDUINOCLI_ROOT "~/AppData/Local/Arduino15")
    endif()
endif()

get_filename_component(ARDUINOCLI_ROOT "${ARDUINOCLI_ROOT}" ABSOLUTE)

if(NOT EXISTS ${ARDUINOCLI_ROOT})
    message(FATAL_ERROR
        "tools directory of arduino-cli not found. (expected: ${ARDUINOCLI_ROOT})\n"
        "Solution:\n"
        "1. check if arduino-cli and avr core were installed\n"
        "2. please set correct path to environment variable ARDUINOCLI_ROOT if you installed arduino-cli to custom directory\n"
    )
endif()

# Find avr-gcc variants from arduino-cli
file(GLOB AVRGCC_VARIANTS ${ARDUINOCLI_ROOT}/packages/arduino/tools/avr-gcc/*)

# If multiple variants hit, choose latest version
set(AVRGCC_VARIANTS_COUNT 0)
list(LENGTH AVRGCC_VARIANTS AVRGCC_VARIANTS_COUNT)
list(SORT AVRGCC_VARIANTS ORDER DESCENDING)
list(GET AVRGCC_VARIANTS 0 AVRGCC_ROOT)

if(NOT AVRGCC_ROOT)
    message(FATAL_ERROR "AVR toolchain not found.")
endif()

set(AVR_TOOLCHAIN_ROOT ${AVRGCC_ROOT}/bin)

# #
# # configure CMake for AVR
# #

# paths, constants
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_CROSS_COMPILING 1)

set(CMAKE_C_COMPILER "${AVR_TOOLCHAIN_ROOT}/avr-gcc" CACHE PATH "gcc" FORCE)
set(CMAKE_CXX_COMPILER "${AVR_TOOLCHAIN_ROOT}/avr-g++" CACHE PATH "g++" FORCE)
set(CMAKE_LINKER "${AVR_TOOLCHAIN_ROOT}/avr-ld" CACHE PATH "linker" FORCE)

set(CMAKE_NM "${AVR_TOOLCHAIN_ROOT}/avr-nm" CACHE PATH "nm" FORCE)
set(CMAKE_OBJCOPY "${AVR_TOOLCHAIN_ROOT}/avr-objcopy" CACHE PATH "objcopy" FORCE)
set(CMAKE_OBJDUMP "${AVR_TOOLCHAIN_ROOT}/avr-objdump" CACHE PATH "objdump" FORCE)

set(CMAKE_AR "${AVR_TOOLCHAIN_ROOT}/avr-ar" CACHE PATH "ar" FORCE)
set(CMAKE_STRIP "${AVR_TOOLCHAIN_ROOT}/avr-strip" CACHE PATH "strip" FORCE)
set(CMAKE_RANLIB "${AVR_TOOLCHAIN_ROOT}/avr-ranlib" CACHE PATH "ranlib" FORCE)

# compiler flags
set(COMMON_FLAGS "-mmcu=${AVR_MCU} -DF_CPU=${AVR_FCPU}")

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(OPTIMIZATION_FLAGS "-Os")
else()
    set(OPTIMIZATION_FLAGS "-Os -g")
endif()

set(COMPILER_FLAGS "${COMMON_FLAGS} ${OPTIMIZATION_FLAGS}")
set(LINKER_FLAGS "${COMMON_FLAGS} -lc")

# #
# # custom macros
# #

# add_executable
macro(add_executable_avr target_name)
    add_executable(${target_name}
        ${ARGN}
    )

    set_target_properties(${target_name} PROPERTIES
        COMPILE_FLAGS "${COMPILER_FLAGS}"
        LINK_FLAGS "${LINKER_FLAGS}"
    )

    target_include_directories(${target_name} PUBLIC
        ${AVRGCC_ROOT}/avr/include
    )

    target_link_directories(${target_name} PUBLIC
        ${AVRGCC_ROOT}/avr/lib
    )
endmacro()

# add_library
macro(add_library_avr target_name)
    add_library(${target_name}
        ${ARGN}
    )

    set_target_properties(${target_name} PROPERTIES
        COMPILE_FLAGS "${COMPILER_FLAGS}"
        LINK_FLAGS "${LINKER_FLAGS}"
    )

    target_include_directories(${target_name} PUBLIC
        ${AVRGCC_ROOT}/avr/include
    )

    target_link_directories(${target_name} PUBLIC
        ${AVRGCC_ROOT}/avr/lib
    )
endmacro()
