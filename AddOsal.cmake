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

find_package(Osal QUIET)

if (NOT Osal_FOUND)
  include(FetchContent)
  FetchContent_Declare(
    Osal
    GIT_REPOSITORY      https://github.com/rtlabs-com/osal.git
    GIT_TAG             37f7786
    )
  FetchContent_MakeAvailable(Osal)
endif()
