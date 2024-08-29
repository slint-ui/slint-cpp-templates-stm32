function(try_download_prebuilt_slint_binary slint_version rust_target)

    if (DEFINED CACHE{SLINT_GITHUB_RELEASE})
        set(github_release $CACHE{SLINT_GITHUB_RELEASE})
    else()
        set(github_release slint_version)
    endif()

    set(prebuilt_archive_filename "Slint-cpp-${slint_version}-Linux-x86_64-${rust_target}.tar.gz")
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
    find_package(Slint CONFIG)
endfunction()

function(build_slint_from_source slint_version rust_target)
    set(SLINT_FEATURE_FREESTANDING ON)
    set(SLINT_FEATURE_RENDERER_SOFTWARE ON)
    set(DEFAULT_SLINT_EMBED_RESOURCES "embed-for-software-renderer" CACHE STRING "")
    set(CMAKE_BUILD_TYPE Release)
    set(BUILD_SHARED_LIBS OFF)
    set(Rust_CARGO_TARGET ${rust_target})

    if ($CACHE{SLINT_GITHUB_RELEASE} STREQUAL "nightly")
        set(git_tag "master")
    else()
        set(git_tag "v${slint_version}")
    endif()

    include(FetchContent)
    FetchContent_Declare(
        Slint
        GIT_REPOSITORY https://github.com/slint-ui/slint
        GIT_TAG ${git_tag}
        SOURCE_SUBDIR api/cpp
    )
    FetchContent_MakeAvailable(Slint)
endfunction()

try_download_prebuilt_slint_binary(${Slint_FIND_VERSION} thumbv7em-none-eabihf)
if (NOT TARGET Slint::Slint)
   build_slint_from_source(${Slint_FIND_VERSION} thumbv7em-none-eabihf)
endif()