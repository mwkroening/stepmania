list(APPEND FFMPEG_CONFIGURE_OPTIONS
            "--cc=$ENV{CC}"
            "--host-cflags=$ENV{CFLAGS}"
            "--host-ldflags=$ENV{LDFLAGS}"
            "--disable-programs"
            "--disable-doc"
            "--disable-avdevice"
            "--disable-swresample"
            "--disable-postproc"
            "--disable-avfilter"
            "--disable-shared"
            "--enable-static")

if(CMAKE_POSITION_INDEPENDENT_CODE)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--enable-pic")
endif()

#if(MACOSX)
#  find_program(FFMPEG_YASM_EXECUTABLE yasm
#               PATHS /usr/bin /usr/local/bin /opt/local/bin)
#  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--yasmexe=${FFMPEG_YASM_EXECUTABLE}")
#endif()

if(WITH_GPL_LIBS)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--enable-gpl")
endif()

if(WITH_CRYSTALHD_DISABLED)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--disable-crystalhd")
endif()

if(NOT WITH_EXTERNAL_WARNINGS)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--extra-cflags=-w")
endif()

if(WITH_FFMPEG_JOBS GREATER 0)
  set(JOBS_ARG -j${WITH_FFMPEG_JOBS})
endif()

find_program(MAKE_EXE NAMES gmake nmake make)
externalproject_add(ffmpeg
  GIT_REPOSITORY    https://git.ffmpeg.org/ffmpeg.git
  GIT_TAG           n4.2
  GIT_SHALLOW       TRUE
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> ${FFMPEG_CONFIGURE_OPTIONS}
  BUILD_COMMAND     ${MAKE_EXE} ${JOBS_ARG}
#  INSTALL_COMMAND   ""
)

externalproject_get_property(ffmpeg SOURCE_DIR)
externalproject_get_property(ffmpeg BINARY_DIR)
find_package(FFMPEG REQUIRED
  COMPONENTS        avcodec avformat avutil
  PATH              ${BINARY_DIR}
                    ${SOURCE_DIR})

# BINARY_DIR includes libavutil/avconfig.h
#set(FFMPEG_INCLUDE_DIRS ${SOURCE_DIR} ${BINARY_DIR})
#set(FFMPEG_STATIC_LIBRARY_DIRS ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavformat
#                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libswscale
#                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavcodec
#                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavutil)
# TODO: Use target_link_directories when upgrading to cmake 3.13
#link_directories(${FFMPEG_STATIC_LIBRARY_DIRS})
#if(APPLE)
#  set(FFMPEG_STATIC_LIBRARIES avformat m bz2 z swscale m avcodec iconv m lzma z avutil m)
#elseif(UNIX)
#  set(FFMPEG_STATIC_LIBRARIES avformat bz2 swscale avcodec lzma z avutil va-drm va-x11 vdpau m va Xv X11 Xext)
#endif()

# Use this to update FFMPEG_STATIC_LIBRARY_DIRS and FFMPEG_STATIC_LIBRARIES
# after a FFmpeg upgrade.
#if(PRINT_FFMPEG_ARGS)
#  include(FindPkgConfig)
#  externalproject_get_property(ffmpeg BINARY_DIR)
#  set(ENV{PKG_CONFIG_PATH} ${BINARY_DIR}/doc/examples/pc-uninstalled/)
#  pkg_check_modules(FFMPEG REQUIRED libavformat-uninstalled
#                                    libswscale-uninstalled
#                                    libavcodec-uninstalled
#                                    libavutil-uninstalled)
#  message("Static library dirs: " "${FFMPEG_STATIC_LIBRARY_DIRS}")
#  message("Static libraries: " "${FFMPEG_STATIC_LIBRARIES}")
#endif()
