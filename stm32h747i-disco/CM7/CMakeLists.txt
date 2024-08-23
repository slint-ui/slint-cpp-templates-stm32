cmake_minimum_required(VERSION 3.22)

#
# This file is generated only once,
# and is not re-generated if converter is called multiple times.
#
# User is free to modify the file as much as necessary
#

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# Define the build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

message("Build type: " ${CMAKE_BUILD_TYPE})

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Compiler options
set(STM32_MCU_FLAGS  "-mcpu=cortex-m7 -mfpu=fpv5-d16 -mfloat-abi=hard " )

#Linker options
set(STM32_LINKER_SCRIPT stm32h747xx_flash_CM7.ld)
set(STM32_LINKER_OPTION  )

# Include toolchain file
include("../gcc-arm-none-eabi.cmake")

# Set the project name
set(CMAKE_PROJECT_NAME slint-cpp-template-stm32h747i-disco_CM7)
project(${CMAKE_PROJECT_NAME})

set(SLINT_STYLE "fluent-light")

function(try_download_prebuilt_slint_binary slint_version rust_target)
    cmake_parse_arguments(option "" "GITHUB_RELEASE" "" ${ARGN})

    if (DEFINED option_GITHUB_RELEASE)
        set(github_release "${option_GITHUB_RELEASE}")
    else()
        set(github_release "${slint_version}")
    endif()

    if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        set(package_system_name "win64-MSVC")
    else()
        set(package_system_name "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}")
    endif()

    set(prebuilt_archive_filename "Slint-cpp-${slint_version}-${package_system_name}-${rust_target}.tar.gz")
    set(download_target_path "${CMAKE_BINARY_DIR}/slint-prebuilt/")
    set(download_url "https://github.com/slint-ui/slint/releases/download/${github_release}/${prebuilt_archive_filename}")

    file(MAKE_DIRECTORY "${download_target_path}")
    message(STATUS "Downloading pre-built Slint binary ${download_url}")
    file(DOWNLOAD "${download_url}" "${download_target_path}/${prebuilt_archive_filename}" STATUS download_status)
    list(GET download_status 0 download_code)
    if (NOT download_code EQUAL 0)
        list(GET download_status 1 download_message)
        message(STATUS "Download of Slint binary package failed: ${download_message}")
        return()
    endif()

    file(ARCHIVE_EXTRACT INPUT "${download_target_path}/${prebuilt_archive_filename}" DESTINATION "${download_target_path}")
    list(PREPEND CMAKE_PREFIX_PATH "${download_target_path}")
    find_package(Slint)
endfunction()

function(build_slint_from_source git_tag rust_target)
    set(SLINT_FEATURE_FREESTANDING ON)
    set(SLINT_FEATURE_RENDERER_SOFTWARE ON)
    set(DEFAULT_SLINT_EMBED_RESOURCES "embed-for-software-renderer" CACHE STRING "")
    set(CMAKE_BUILD_TYPE Release)
    set(BUILD_SHARED_LIBS OFF)
    set(Rust_CARGO_TARGET ${rust_target})

    include(FetchContent)
    FetchContent_Declare(
        Slint
        GIT_REPOSITORY https://github.com/slint-ui/slint
        GIT_TAG ${git_tag}
        SOURCE_SUBDIR api/cpp
    )
    FetchContent_MakeAvailable(Slint)
endfunction()

try_download_prebuilt_slint_binary(1.8.0 thumbv7em-none-eabihf GITHUB_RELEASE "nightly")
if (NOT TARGET Slint::Slint)
   build_slint_from_source(master thumbv7em-none-eabihf)
endif()

set(DEFAULT_SLINT_EMBED_RESOURCES embed-for-software-renderer)

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Include mx-generated
include("mx-generated.cmake")

# Enable CMake support for ASM and C languages
enable_language(C CXX ASM)

# In order to use CMake for cross-compiling
set(CMAKE_CXX_COMPILER_FORCED "true")

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined symbols
    SLINT_STM32_BSP_NAME=stm32h747i_discovery
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined include paths
    ../Drivers/BSP/STM32H747I-DISCO/
    ../Drivers/BSP/Components/Common
    ../Drivers/BSP/Components/mt25tl01g
    ../Drivers/STM32H7xx_HAL_Driver/Inc
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user sources here
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery.c
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery_lcd.c
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery_ts.c
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery_sdram.c
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery_bus.c
    ../Drivers/BSP/STM32H747I-DISCO/stm32h747i_discovery_qspi.c
    ../Drivers/BSP/Components/nt35510/nt35510.c
    ../Drivers/BSP/Components/nt35510/nt35510_reg.c
    ../Drivers/BSP/Components/otm8009a/otm8009a.c
    ../Drivers/BSP/Components/otm8009a/otm8009a_reg.c
    ../Drivers/BSP/Components/ft6x06/ft6x06.c
    ../Drivers/BSP/Components/ft6x06/ft6x06_reg.c
    ../Drivers/BSP/Components/is42s32800j/is42s32800j.c
    ../Drivers/BSP/Components/mt25tl01g/mt25tl01g.c

    ./Core/Src/appmain.cpp
)

slint_target_sources(${CMAKE_PROJECT_NAME} ./Core/Src/ui/appwindow.slint)
set_property(TARGET ${CMAKE_PROJECT_NAME} APPEND PROPERTY SLINT_SCALE_FACTOR 2)

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined library search paths
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined libraries
    Slint::Slint
)

# Validate that STM32CubeMX code is compatible with C standard
if(CMAKE_C_STANDARD LESS 11)
    message(ERROR "Generated code requires C11 or higher")
endif()









