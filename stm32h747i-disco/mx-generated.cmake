# File automatically-generated by STM32CubeMX - Do not modify
set(ST_MULTICONTEXT DUAL_CORE CACHE STRING "Type of multi-context")
#-----------------------Build CM4 Project-----------------------#
if((${BUILD_CONTEXT} MATCHES .*CM4.*) OR (NOT DEFINED BUILD_CONTEXT))
    message("   Build context: " CM4)
    ExternalProject_Add(slint-cpp-template-stm32h747i-disco_CM4
        BINARY_DIR                  ${CMAKE_SOURCE_DIR}/CM4/build
        SOURCE_DIR                  ${PROJECT_SOURCE_DIR}/CM4
        PREFIX                      CM4
        CONFIGURE_HANDLED_BY_BUILD  true
        INSTALL_COMMAND             ""
        CMAKE_ARGS                  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    )
	set(ST_DUAL_CORE_CM4_PROJECT_BUILD_TARGET ${CMAKE_SOURCE_DIR}/CM4/build/slint-cpp-template-stm32h747i-disco_CM4${CMAKE_EXECUTABLE_SUFFIX_CXX} CACHE FILEPATH "Path to cm4 project target")
endif()
#-----------------------Build CM7 Project-----------------------#
if((${BUILD_CONTEXT} MATCHES .*CM7.*) OR (NOT DEFINED BUILD_CONTEXT))
    message("   Build context: " CM7)
    ExternalProject_Add(slint-cpp-template-stm32h747i-disco_CM7
        BINARY_DIR                  ${CMAKE_SOURCE_DIR}/CM7/build
        SOURCE_DIR                  ${PROJECT_SOURCE_DIR}/CM7
        PREFIX                      CM7
        CONFIGURE_HANDLED_BY_BUILD  true
        INSTALL_COMMAND             ""
        CMAKE_ARGS                  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    )
	set(ST_DUAL_CORE_CM7_PROJECT_BUILD_TARGET ${CMAKE_SOURCE_DIR}/CM7/build/slint-cpp-template-stm32h747i-disco_CM7${CMAKE_EXECUTABLE_SUFFIX_CXX} CACHE FILEPATH "Path to cm7 project target")
endif()
