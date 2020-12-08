
cmake_minimum_required(VERSION 3.14)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

include(FetchContent)
FetchContent_Declare(
  googletest
#  GIT_REPOSITORY      https://github.com/google/googletest.git
#  GIT_TAG             release-1.10.0
  GIT_REPOSITORY      https://github.com/rtlabs-com/googletest.git
  GIT_TAG             cc602bd729c3acd610c3de5d65d1f1d598c41522
  )
FetchContent_GetProperties(googletest)
if(NOT googletest_POPULATED)
  FetchContent_Populate(googletest)
  set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE BOOL "")
  add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR} EXCLUDE_FROM_ALL)
  unset(CMAKE_SUPPRESS_DEVELOPER_WARNINGS)
endif()

add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND}
  --force-new-ctest-process
  --output-on-failure
  --build-config "$<CONFIGURATION>")
set_target_properties(check PROPERTIES FOLDER "Scripts")

if(GOOGLE_TEST_INDIVIDUAL)
  include(GoogleTest)
endif()

macro(add_gtest TESTNAME)
  target_link_libraries(${TESTNAME} PUBLIC gtest)

  if (BUILD_GMOCK)
    target_link_libraries(${TESTNAME} PUBLIC gmock)
  endif()

  if(GOOGLE_TEST_INDIVIDUAL)
    gtest_discover_tests(${TESTNAME}
      TEST_PREFIX "${TESTNAME}."
      PROPERTIES FOLDER "Tests")
  else()
    add_test(${TESTNAME} ${TESTNAME})
    set_target_properties(${TESTNAME} PROPERTIES FOLDER "Tests")
  endif()

endmacro()

mark_as_advanced(
  gmock_build_tests
  gtest_build_samples
  gtest_build_tests
  gtest_disable_pthreads
  gtest_force_shared_crt
  gtest_hide_internal_symbols
  BUILD_GMOCK
  BUILD_GTEST
  )

set_target_properties(gtest gtest_main
  PROPERTIES FOLDER "Extern")

if(BUILD_GMOCK)
  set_target_properties(gmock gmock_main
    PROPERTIES FOLDER "Extern")
endif()
