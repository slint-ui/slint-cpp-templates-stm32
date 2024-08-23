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

# Set the project name
set(CMAKE_PROJECT_NAME stm32h735g-dk)

# Include toolchain file
include("cmake/gcc-arm-none-eabi.cmake")

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Enable CMake support for ASM and C languages
enable_language(C CXX ASM)

# Core project settings
project(${CMAKE_PROJECT_NAME})
message("Build type: " ${CMAKE_BUILD_TYPE})

set(SLINT_STYLE "fluent-light")

function(try_download_prebuilt_slint_binary slint_version target_arch)
    cmake_parse_arguments(option "" "TARGET_ARCH;GITHUB_RELEASE" "" ${ARGN})

    if (DEFINED option_GITHUB_RELEASE)
        set(github_release "${option_GITHUB_RELEASE}")
    else()
        set(github_release "${slint_version}")
    endif()

    set(prebuilt_archive_filename "Slint-cpp-${slint_version}-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}-${target_arch}.tar.gz")
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

function(build_slint_from_source slint_version target_arch)
    set(SLINT_FEATURE_FREESTANDING ON)
    set(SLINT_FEATURE_RENDERER_SOFTWARE ON)
    set(DEFAULT_SLINT_EMBED_RESOURCES "embed-for-software-renderer" CACHE STRING "")
    set(CMAKE_BUILD_TYPE Release)
    set(BUILD_SHARED_LIBS OFF)
    set(Rust_CARGO_TARGET ${target_arch})

    include(FetchContent)
    FetchContent_Declare(
        Slint
        GIT_REPOSITORY https://github.com/slint-ui/slint
        GIT_REPOSITORY file:///Users/simon/src/slint
        GIT_TAG master
        SOURCE_SUBDIR api/cpp
    )
    FetchContent_MakeAvailable(Slint)
endfunction()

try_download_prebuilt_slint_binary(1.8.0 thumbv7em-none-eabihf GITHUB_RELEASE "nightly")
if (NOT TARGET Slint::Slint)
   build_slint_from_source(1.8.0 thumbv7em-none-eabihf)
endif()

set(DEFAULT_SLINT_EMBED_RESOURCES embed-for-software-renderer)

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add STM32CubeMX generated sources
add_subdirectory(cmake/stm32cubemx)

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined library search paths
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user sources here
    ./Drivers/BSP/STM32H735G-DK/stm32h735g_discovery.c
    ./Drivers/BSP/STM32H735G-DK/stm32h735g_discovery_lcd.c
    ./Drivers/BSP/STM32H735G-DK/stm32h735g_discovery_ts.c
    ./Drivers/BSP/STM32H735G-DK/stm32h735g_discovery_ospi.c
    ./Drivers/BSP/STM32H735G-DK/stm32h735g_discovery_bus.c
    ./Drivers/BSP/Components/ft5336/ft5336.c
    ./Drivers/BSP/Components/ft5336/ft5336_reg.c
    ./Drivers/BSP/Components/s70kl1281/s70kl1281.c

    ./Core/Src/appmain.cpp
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined include paths
    ./Drivers/BSP/STM32H735G-DK
    ./Drivers/BSP/Components/Common
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined symbols
    SLINT_STM32_BSP_NAME=stm32h735g_discovery
)

slint_target_sources(${CMAKE_PROJECT_NAME}
    ./Core/Src/ui/appwindow.slint
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
    stm32cubemx
    Slint::Slint
    # Add user defined libraries
)
