list(APPEND FFMPEG_CONFIGURE_OPTIONS
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

if(MACOSX)
  find_program(FFMPEG_YASM_EXECUTABLE yasm
               PATHS /usr/bin /usr/local/bin /opt/local/bin)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--yasmexe=${FFMPEG_YASM_EXECUTABLE}")
endif()

if(WITH_GPL_LIBS)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--enable-gpl")
endif()

if(WITH_CRYSTALHD_DISABLED)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--disable-crystalhd")
endif()

if(NOT WITH_EXTERNAL_WARNINGS)
  list(APPEND FFMPEG_CONFIGURE_OPTIONS "--extra-cflags=-w")
endif()

# PKG_CONFIG_PATH=ffmpeg-prefix/src/ffmpeg-build/* PKG_CONFIG_SYSROOT_DIR=. pkg-config --define-variable=prefix=/foo --cflags --libs --static libavformat libavcodec libswscale libavutil
# PKG_CONFIG_PATH=ffmpeg-prefix/src/ffmpeg-build/doc/examples/pc-uninstalled/ pkg-config --cflags --libs --static libavformat

if (WITH_FFMPEG_JOBS GREATER 0)
  set(JOBS_ARG -j${WITH_FFMPEG_JOBS})
endif()

find_program(MAKE_EXE NAMES gmake nmake make)
externalproject_add(ffmpeg
  GIT_REPOSITORY    https://git.ffmpeg.org/ffmpeg.git
  GIT_TAG           n4.2
  GIT_SHALLOW       TRUE
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${FFMPEG_CONFIGURE_OPTIONS}
  BUILD_COMMAND     ${MAKE_EXE} ${JOBS_ARG}
  INSTALL_COMMAND   ""
)

externalproject_get_property(ffmpeg SOURCE_DIR)
set(FFMPEG_INCLUDE_DIR ${SOURCE_DIR})
externalproject_get_property(ffmpeg BINARY_DIR)
set(FFMPEG_STATIC_LIBRARY_DIRS ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavformat
                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavcodec
                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libavutil
                               ${BINARY_DIR}/doc/examples/pc-uninstalled/../../../libswscale)
# TODO: Use target_link_directories when upgrading to cmake 3.13
link_directories(${FFMPEG_STATIC_LIBRARY_DIRS})
set(FFMPEG_STATIC_LIBRARIES avformat bz2 swscale avcodec lzma z avutil va-drm va-x11 vdpau m va Xv X11 Xext)

# Use this to update FFMPEG_STATIC_LIBRARY_DIRS and FFMPEG_STATIC_LIBRARIES
# after a FFmpeg upgrade.
if(FALSE)
  externalproject_get_property(ffmpeg BINARY_DIR)
  set(ENV{PKG_CONFIG_PATH} ${BINARY_DIR}/doc/examples/pc-uninstalled/)
  pkg_check_modules(FFMPEG REQUIRED libavformat-uninstalled
                                    libswscale-uninstalled
                                    libavcodec-uninstalled
                                    libavutil-uninstalled)
  message(WARNING "${FFMPEG_STATIC_LIBRARY_DIRS}")
  message(FATAL_ERROR "${FFMPEG_STATIC_LIBRARIES}")
endif()


#list(APPEND FFMPEG_LIBRARIES
#            ${BINARY_DIR}/libavformat/libavformat.a
#            ${BINARY_DIR}/libavcodec/libavcodec.a
#            ${BINARY_DIR}/libswscale/libswscale.a
#            ${BINARY_DIR}/libavutil/libavutil.a
#)
