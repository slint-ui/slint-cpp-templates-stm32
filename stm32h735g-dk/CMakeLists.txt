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

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(SLINT_TARGET_ARCHITECTURE thumbv7em-none-eabihf)
find_package(Slint)

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
    ./Core/Src/ui/app-window.slint
)

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    SLINT_EMBED_RESOURCES embed-for-software-renderer
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
    stm32cubemx
    Slint::Slint
    # Add user defined libraries
)
