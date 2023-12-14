#!/bin/bash

#./run.sh compile_flash prj01_cli_parser NO

if [ $1 == 'compile_flash' ]
then
mkdir -p build
cd build
cmake -DPROJECT_CORE_FILES=$2 -DDO_FLASH=YES -DIS_FREERTOS_ENABLED=$3 ..
make -j11

cd ..

elif [ $1 == 'compile_only' ]
then
mkdir -p build
cd build
cmake -DPROJECT_CORE_FILES=$2 -DDO_FLASH=NO -DIS_FREERTOS_ENABLED=$3 ..
make -j11

cd ..


elif [ $1 == 'clean' ]
then
mkdir -p build
cd build
rm -r *
echo 'cleaned successfully'
cd ..

elif [ $1 == 'monitor' ]
then
mkdir -p build
cd build
rm -r *
sudo picocom -b 115200 /dev/ttyACM0
cd ..

elif [ $1 == 'flash' ]
then
sudo openocd -f openocd.cfg -c "program build/stm32f446re_test.elf verify reset exit"

fi

