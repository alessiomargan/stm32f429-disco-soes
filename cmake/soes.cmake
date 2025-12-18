# SOES and application integration (kept outside CubeMX generated CMake)

# Resolve external paths
if(NOT DEFINED GIT_SOES)
    set(GIT_SOES "$ENV{GIT_SOES}")
    if(NOT GIT_SOES)
        message(STATUS "GIT_SOES not set, using default path")
        set(GIT_SOES "/home/amargan/work/code/firmware/SOES")
    endif()
endif()
message(STATUS "GIT_SOES: ${GIT_SOES}")

if(NOT DEFINED GIT_UC_TEST)
    set(GIT_UC_TEST "$ENV{GIT_UC_TEST}")
    if(NOT GIT_UC_TEST)
        message(STATUS "GIT_UC_TEST not set, using default path")
        set(GIT_UC_TEST "/home/amargan/work/code/firmware/uc_test")
    endif()
endif()
message(STATUS "GIT_UC_TEST: ${GIT_UC_TEST}")

# SOES include paths
set(SOES_INCLUDE_DIRS
    ${GIT_SOES}
    ${GIT_SOES}/soes
    ${GIT_SOES}/soes/include
    ${GIT_SOES}/soes/include/sys/gcc
    ${GIT_SOES}/soes/hal/advr_esc
    ${GIT_UC_TEST}/common_src/soes_test/include
    ${GIT_UC_TEST}/stm32f4xx/soes_test/include
)

# SOES EtherCAT sources
set(SOES_SOURCES
    ${GIT_SOES}/soes/ecat_slv.c
    ${GIT_SOES}/soes/esc.c
    ${GIT_SOES}/soes/esc_coe.c
    ${GIT_SOES}/soes/esc_eep.c
    ${GIT_SOES}/soes/esc_eoe.c
    ${GIT_SOES}/soes/esc_foe.c
    ${GIT_SOES}/soes/hal/advr_esc/esc_hw_et1100.c
    ${GIT_SOES}/soes/hal/advr_esc/hal_ec_STM32F4xx.c
)

# Application / test sources
set(UC_TEST_COMMON_SOURCES
    ${GIT_UC_TEST}/common_src/soes_test/globals.c
    ${GIT_UC_TEST}/common_src/soes_test/objectlist.c
    ${GIT_UC_TEST}/common_src/soes_test/params.c
    ${GIT_UC_TEST}/common_src/soes_test/soes_hook.c
)

set(UC_TEST_STM32F4_SOURCES
    ${GIT_UC_TEST}/stm32f4xx/soes_test/user_code.c
    ${GIT_UC_TEST}/stm32f4xx/soes_test/flash_utils.c
)

set(UC_TEST_SOURCES ${UC_TEST_COMMON_SOURCES} ${UC_TEST_STM32F4_SOURCES})

# Attach include dirs to the stm32cubemx interface so both STM32_Drivers and the app see them
if(TARGET stm32cubemx)
    target_include_directories(stm32cubemx INTERFACE ${SOES_INCLUDE_DIRS})
endif()

# Add SOES and application sources to the STM32_Drivers object library
if(TARGET STM32_Drivers)
    target_sources(STM32_Drivers PRIVATE ${SOES_SOURCES} ${UC_TEST_SOURCES})
endif()

# Pre-build step: generate build info
if(TARGET ${CMAKE_PROJECT_NAME})
    add_custom_command(TARGET ${CMAKE_PROJECT_NAME} PRE_BUILD
        COMMAND /bin/bash ${GIT_UC_TEST}/common_src/gen_build_info.sh ${GIT_UC_TEST}/common_src/soes_test
        COMMENT "Generating build info..."
        VERBATIM
    )
endif()

# Post-build step: copy firmware binary to ecat_master
if(TARGET ${CMAKE_PROJECT_NAME})
    add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
        COMMAND mkdir -p $ENV{HOME}/.ecat_master/firmware
        COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_ORIGINAL_NAME}.bin $ENV{HOME}/.ecat_master/firmware/st_et1100.bin
        COMMENT "Copying firmware to ~/.ecat_master/firmware/st_et1100.bin"
        VERBATIM
    )
endif()
