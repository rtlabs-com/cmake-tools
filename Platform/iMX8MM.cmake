# Prefer standard extensions
#********************************************************************
#        _       _         _
#  _ __ | |_  _ | |  __ _ | |__   ___
# | '__|| __|(_)| | / _` || '_ \ / __|
# | |   | |_  _ | || (_| || |_) |\__ \
# |_|    \__|(_)|_| \__,_||_.__/ |___/
#
# www.rt-labs.com
# Copyright 2021 rt-labs AB, Sweden.
# Copyright 2023 NXP
#
# This software is licensed under the terms of the BSD 3-clause
# license. See the file LICENSE distributed with this software for
# full license information.
#*******************************************************************/

include_guard()
cmake_minimum_required (VERSION 3.1.2)
enable_language(ASM)

# Avoid warning when re-running cmake
set(DUMMY ${CMAKE_TOOLCHAIN_FILE})

# No support for shared libs
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

set(UNIX 1)
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

# Do not build executables during configuration stage. Required
# libraries may not be built yet.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_OUTPUT_EXTENSION_REPLACE 1)
set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE 1)
set(CMAKE_ASM_OUTPUT_EXTENSION_REPLACE 1)

SET(CMAKE_ASM_FLAGS_DDR_RELEASE " \
    ${CMAKE_ASM_FLAGS_DDR_RELEASE} \
    -D__STARTUP_CLEAR_BSS \
    -D__STARTUP_INITIALIZE_NONCACHEDATA \
    -mcpu=cortex-m4 \
    -mfloat-abi=hard \
    -mfpu=fpv4-sp-d16 \
    -mthumb \
")

SET(CMAKE_C_FLAGS_DDR_RELEASE " \
    ${CMAKE_C_FLAGS_DDR_RELEASE} \
    -DCPU_MIMX8MM6DVTLZ \
    -DCPU_MIMX8MM6DVTLZ_cm4 \
    -DPRINTF_FLOAT_ENABLE=0 \
    -DSCANF_FLOAT_ENABLE=0 \
    -DPRINTF_ADVANCED_ENABLE=0 \
    -DSCANF_ADVANCED_ENABLE=0 \
    -DMCUXPRESSO_SDK \
    -DUSE_RTOS=1 \
    -DSDK_OS_FREE_RTOS \
    -Os \
    -mcpu=cortex-m4 \
    -Wno-address-of-packed-member \
    -mfloat-abi=hard \
    -mfpu=fpv4-sp-d16 \
    -mthumb \
    -MMD \
    -MP \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -ffreestanding \
    -fno-builtin \
    -mapcs \
    -std=gnu99 \
")

SET(CMAKE_CXX_FLAGS_DDR_RELEASE " \
    ${CMAKE_CXX_FLAGS_DDR_RELEASE} \
    -DCPU_MIMX8MM6DVTLZ \
    -DCPU_MIMX8MM6DVTLZ_cm4 \
    -DMCUXPRESSO_SDK \
    -Os \
    -mcpu=cortex-m4 \
    -Wno-address-of-packed-member \
    -mfloat-abi=hard \
    -mfpu=fpv4-sp-d16 \
    -mthumb \
    -MMD \
    -MP \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -ffreestanding \
    -fno-builtin \
    -mapcs \
    -fno-rtti \
    -fno-exceptions \
")

SET(CMAKE_EXE_LINKER_FLAGS_DDR_RELEASE " \
    ${CMAKE_EXE_LINKER_FLAGS_DDR_RELEASE} \
    -mcpu=cortex-m4 \
    -Wall \
    -mfloat-abi=hard \
    -mfpu=fpv4-sp-d16 \
    -Wl,--print-memory-usage \
    -Wl,-s \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -ffreestanding \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -Xlinker \
    --gc-sections \
    -Xlinker \
    -static \
    -Xlinker \
    -z \
    -Xlinker \
    muldefs \
    -Xlinker \
    -Map=output.map \
")

# Common includes
list (APPEND INCLUDES
  # nothing yet
  )

set(CMAKE_ASM_STANDARD_INCLUDE_DIRECTORIES ${INCLUDES})
set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${INCLUDES})
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${INCLUDES})

  # Libraries
list (APPEND LIBS
-lc
-lm
-lnosys
)
list(JOIN LIBS " " LIBS) # Convert list to space separated string
set(CMAKE_C_STANDARD_LIBRARIES ${LIBS})
set(CMAKE_CXX_STANDARD_LIBRARIES "${LIBS} -lstdc++")

# Macro to add .bin output
macro(generate_bin TARGET)
add_custom_command(TARGET ${TARGET} POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${TARGET}.elf ${TARGET}.bin
  )
endmacro()