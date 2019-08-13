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
externalproject_add(ffmpeg_ext
  GIT_REPOSITORY    https://git.ffmpeg.org/ffmpeg.git
  GIT_TAG           n4.2
  GIT_SHALLOW       TRUE
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> ${FFMPEG_CONFIGURE_OPTIONS}
  BUILD_COMMAND     ${MAKE_EXE} ${JOBS_ARG}
  EXCLUDE_FROM_ALL  ON
#  INSTALL_COMMAND   ""
)

externalproject_get_property(ffmpeg_ext INSTALL_DIR)
#find_package(FFMPEG
#  COMPONENTS        avcodec avformat avutil
#  PATH              ${INSTALL_DIR}
#)

find_package(PkgConfig REQUIRED)
externalproject_get_property(ffmpeg_ext INSTALL_DIR)
set(ENV{PKG_CONFIG_PATH} ${INSTALL_DIR}/lib/pkgconfig)
set(FFMPEG_FOUND 0)
pkg_check_modules(FFMPEG libavcodec libavformat libavutil libswscale)
link_directories(${FFMPEG_STATIC_LIBRARY_DIRS})
message("FFMPEG_LIBRARY_DIRS => ${FFMPEG_LIBRARY_DIRS}")
message("FFMPEG_STATIC_LIBRARIES => ${FFMPEG_STATIC_LIBRARIES}")
message("FFMPEG_STATIC_LIBRARY_DIRS => ${FFMPEG_STATIC_LIBRARY_DIRS}")

#unset(AVCODEC_INCLUDE_DIR CACHE)
#find_path(AVCODEC_INCLUDE_DIR libavcodec/avcodec.h
#          PATHS               ${INSTALL_DIR}/include
#          NO_DEFAULT_PATH)
#message("INCLUDEDIR: " ${AVCODEC_INCLUDE_DIR})
#
#unset(AVFORMAT_INCLUDE_DIR CACHE)
#find_path(AVFORMAT_INCLUDE_DIR libavformat/avformat.h
#          PATHS               ${INSTALL_DIR}/include
#          NO_DEFAULT_PATH)
#unset(SWSCALE_INCLUDE_DIR CACHE)
#find_path(SWSCALE_INCLUDE_DIR libswscale/swscale.h
#          PATHS               ${INSTALL_DIR}/include
#          NO_DEFAULT_PATH)
#unset(AVUTIL_INCLUDE_DIR CACHE)
#find_path(AVUTIL_INCLUDE_DIR libavutil/pixdesc.h
#          PATHS               ${INSTALL_DIR}/include
#          NO_DEFAULT_PATH)
#set(FFMPEG_INCLUDE_DIRS ${AVCODEC_INCLUDE_DIR}
#                        ${AVFORMAT_INCLUDE_DIR}
#                        ${AVUTIL_INCLUDE_DIR}
#                        ${SWSCALE_INCLUDE_DIR})
#message("FFMPEG_INCLUDE_DIRS => ${FFMPEG_INCLUDE_DIRS}")

#unset(AVUTIL_STATIC_LIBRARY CACHE)
#find_library(AVCODEC_STATIC_LIBRARY libavcodec.a
#          PATHS               ${INSTALL_DIR}/lib
#          NO_DEFAULT_PATH)
#unset(AVUTIL_STATIC_LIBRARY CACHE)
#find_library(AVFORMAT_STATIC_LIBRARY libavformat.a
#          PATHS               ${INSTALL_DIR}/lib
#          NO_DEFAULT_PATH)
#unset(AVUTIL_STATIC_LIBRARY CACHE)
#find_library(SWSCALE_STATIC_LIBRARY libswscale.a
#          PATHS               ${INSTALL_DIR}/lib
#          NO_DEFAULT_PATH)
#unset(AVUTIL_STATIC_LIBRARY CACHE)
#find_library(AVUTIL_STATIC_LIBRARY libavutil.a
#          PATHS               ${INSTALL_DIR}/lib
#          NO_DEFAULT_PATH)
#set(FFMPEG_STATIC_LIBRARIES ${AVCODEC_STATIC_LIBRARY}
#                     ${AVFORMAT_STATIC_LIBRARY}
#                     ${SWSCALE_STATIC_LIBRARY}
#                     ${AVUTIL_STATIC_LIBRARY})
#message("FFMPEG_STATIC_LIBRARIES => ${FFMPEG_STATIC_LIBRARIES}")

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
