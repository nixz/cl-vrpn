cmake_minimum_required (VERSION 2.8.11)
project (cl-vrpn)

mark_as_advanced(VRPN_LIBUSB_INCLUDE_DIR)
mark_as_advanced(VRPN_INCLUDE_DIR)
mark_as_advanced(VRPN_LIBRARY)

if(NOT EXISTS VRPN_INCLUDE_DIR)
  find_path(VRPN_INCLUDE_DIR vrpn_Tracker.h)
endif()

if(UNIX AND NOT APPLE)
  find_path(VRPN_LIBUSB_INCLUDE_DIR libusb.h PATHS /usr/include /usr/local/include)
  if(NOT EXISTS VRPN_LIBUSB_INCLUDE_DIR)
    # Not all platforms require this directory to be set
    set(VRPN_LIBUSB_INCLUDE_DIR "")
    mark_as_advanced(CLEAR VRPN_LIBUSB_INCLUDE_DIR)
  endif()
endif()

find_library(VRPN_LIBRARY vrpn)
include_directories(${VRPN_INCLUDE_DIR} ${VRPN_LIBUSB_INCLUDE_DIR})
add_library(cl-vrpn cl-vrpnCFFI_wrap.cxx)
target_link_libraries (cl-vrpn LINK_PRIVATE "${VRPN_LIBRARY}")
