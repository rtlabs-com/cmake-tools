#********************************************************************
#        _       _         _
#  _ __ | |_  _ | |  __ _ | |__   ___
# | '__|| __|(_)| | / _` || '_ \ / __|
# | |   | |_  _ | || (_| || |_) |\__ \
# |_|    \__|(_)|_| \__,_||_.__/ |___/
#
# www.rt-labs.com
# Copyright 2020 rt-labs AB, Sweden.
#
# This software is licensed under the terms of the BSD 3-clause
# license. See the file LICENSE distributed with this software for
# full license information.
#*******************************************************************/

cmake_minimum_required(VERSION 3.14)

# Attempt to find externally built OSAL
find_package(Osal QUIET)

if (NOT Osal_FOUND)
  # Download and build OSAL locally as a static library
  include(FetchContent)
  FetchContent_Declare(
    osal
    GIT_REPOSITORY      https://github.com/rtlabs-com/osal.git
    GIT_TAG             44e5a39
    )
  FetchContent_GetProperties(osal)
  if(NOT osal_POPULATED)
    FetchContent_Populate(osal)
    set(BUILD_SHARED_LIBS_OLD ${BUILD_SHARED_LIBS})
    set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "" FORCE)
    add_subdirectory(${osal_SOURCE_DIR} ${osal_BINARY_DIR} EXCLUDE_FROM_ALL)
    set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS_OLD} CACHE BOOL "" FORCE)
    get_property(SUPPORTS_SHARED GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS)
    if (SUPPORTS_SHARED)
      set_property(TARGET osal PROPERTY POSITION_INDEPENDENT_CODE ON)
    endif()
  endif()

  # Hide Osal_DIR to avoid confusion, as it is not used in this
  # configuration
  mark_as_advanced(Osal_DIR)
endif()
