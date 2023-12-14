cmake_minimum_required(VERSION 3.22)

#----------------------------------------------
# Project name
set(MY_PROJECT_NAME nucleo_f446re)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(ELF_CONVERTER arm-none-eabi-objcopy)
set(OBJ_DUMP arm-none-eabi-objdump)
set(SZ arm-none-eabi-size)

# set(CMAKE_AS_COMPILER arm-none-eabi-as)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set (CMAKE_FIND_NO_INSTALL_PREFIX True)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

project (${MY_PROJECT_NAME}
    LANGUAGES CXX C ASM
    )


 

macro(getIncludeDirectoryList basePath)
    FILE(GLOB_RECURSE new_list ${basePath}/*.h)
    SET(dir_list ${basePath} ${includeDirlist})
    FOREACH(file_path ${new_list})
        GET_FILENAME_COMPONENT(dir_path ${file_path} PATH)
        SET(dir_list ${dir_list} ${dir_path})
    ENDFOREACH()
    if(dir_list)    
        LIST(REMOVE_DUPLICATES dir_list)
    endif()
    SET(includeDirlist ${dir_list})
endmacro()

macro(AddSourceRecursive input_target path)
    file(GLOB_RECURSE MY_SOURCE_FILES
        "${path}/*.c"
        "${path}/*.cpp"
    )
    target_sources(${input_target} PUBLIC ${MY_SOURCE_FILES})
    getIncludeDirectoryList(${path})
endmacro()

macro(AddSourceNotRecursive input_target path)
    file(GLOB MY_SOURCE_FILES
        "${path}/*.c"
        "${path}/*.cpp"
    )
    target_sources(${input_target} PUBLIC ${MY_SOURCE_FILES})
    getIncludeDirectoryList(${path})
endmacro()




set(includeDirlist "")
set(ProjectSourceFolderPath ${CMAKE_SOURCE_DIR})
set(MCU "stm32f446re")
set(target ${MCU}_test)
set(OUTPUT_NAME ${target})
set(MY_OUT_DIR build)


set(CMAKE_ASM_FLAGS 
    "-x assembler-with-cpp"
    )

add_executable(${target})

target_compile_definitions(${target} PRIVATE 
    USE_HAL_DRIVER
    STM32F446xx
    )

target_compile_options(${target} PUBLIC 
    # -c
    -Og
    -Wall
    -fdata-sections
    -ffunction-sections
    -g -gdwarf-2
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16 
    -mfloat-abi=hard
    -g -gdwarf-2
    # -MMD -MP -MF"${ProjectSourceFolderPath}/${MY_OUT_DIR}/startup_stm32f446xx.d" ${ProjectSourceFolderPath}/startup_stm32f446xx.s
    )

target_link_options(${target} PUBLIC
    -lc -lm -lnosys
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    -specs=nano.specs
    -specs=nosys.specs
    -T${ProjectSourceFolderPath}/Drivers/STM32F446RETx_FLASH.ld
    # -MMD -MP -MF"${ProjectSourceFolderPath}/${MY_OUT_DIR}/startup_stm32f446xx.d" ${ProjectSourceFolderPath}/Drivers/startup_stm32f446xx.s
    -lc
    -lm
    -lnosys
    -Wl,-Map=${target}.map,--cref
    -Wl,--gc-sections
    )    




AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Projects/${PROJECT_CORE_FILES})
AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Drivers/STM32F4xx_HAL_Driver)
AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Drivers/CMSIS/Device/ST/STM32F4xx/Include)
AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Drivers/CMSIS/Include)

if(IS_FREERTOS_ENABLED STREQUAL "YES")
AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS)
AddSourceNotRecursive(${target} ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source)
AddSourceRecursive(${target} ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F)
endif()

target_include_directories(${target} PUBLIC ${includeDirlist})
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Projects/${PROJECT_CORE_FILES})
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Drivers/STM32F4xx_HAL_Driver/Inc)
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Drivers/CMSIS/Device/ST/STM32F4xx/Include)
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Drivers/CMSIS/Include)

if(IS_FREERTOS_ENABLED STREQUAL "YES")
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/include)
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS)
target_include_directories(${target} PUBLIC ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F)
endif()

target_sources(${target} PUBLIC 
    ${ProjectSourceFolderPath}/Drivers/startup_stm32f446xx.s
)

if(IS_FREERTOS_ENABLED STREQUAL "YES")
target_sources(${target} PUBLIC 
    ${ProjectSourceFolderPath}/Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/heap_4.c
)
endif()

set_target_properties( ${target} 
        PROPERTIES LINKER_LANGUAGE C
		OUTPUT_NAME ${OUTPUT_NAME}.elf
        RUNTIME_OUTPUT_DIRECTORY .
        )

add_custom_command(TARGET ${target}
        POST_BUILD
        COMMENT Building hex & bin files
        COMMAND ${ELF_CONVERTER} -O ihex ${OUTPUT_NAME}.elf ${OUTPUT_NAME}.hex
        COMMAND ${ELF_CONVERTER} -O binary -S ${OUTPUT_NAME}.elf ${OUTPUT_NAME}.bin
        COMMAND ${SZ} ${OUTPUT_NAME}.elf
        VERBATIM
)  

if(DO_FLASH STREQUAL "YES")
    add_custom_command(TARGET ${target}
            POST_BUILD
            COMMENT Flashing MCU
            COMMAND sudo openocd -f ${ProjectSourceFolderPath}/openocd.cfg -c "program ${OUTPUT_NAME}.elf verify reset exit"
            VERBATIM
    ) 

endif()


