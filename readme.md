# Temperature Controlled with DC Fan using stm32 NUCLEO_F446RE.

This project  the idea of controlling the fan based on the variation of temperature. Through this project we intended:

 1. To build a system to detect temperature of the room and execute the contrast of the current temperature.
 2. Making a system that does not allow the room temperature to rise above a certain limit.
 3. To erect a time-saving and use worthy set-up.
 4. Assembling this structure to reduce the usage of electricity, minimizing power wastage and save money.

 Temperature controlling is required in many places such as server rooms, houses, industries, etc. So, stm32 microcontroller based temperature controlled DC fan project is very useful, which can be used anywhere. This project works in three parts: At first, the sensor senses the temperature by temperature and humidity sensor namely BMP180. Secondly, the sensor's output is taken and conversion of temperature value into a suitable number in Celsius scale is done. The fan controlled by using PWM signals. And last part of the system shows temperature on LCD and Fan ON and off.

## Temperature Thresholds:

 There are two temperature thresholds specified in the code (greater than 23 and less than 22).
 If the temperature rises above the upper threshold, the fan is turned on gradually.
 If the temperature falls below the lower threshold, the fan is turned off gradually.

## Hysteresis Range:

 The hysteresis range is the difference between the upper and lower thresholds .
 This range prevents the fan from turning on and off rapidly around a specific temperature point, reducing unnecessary switching.
 Gradual Adjustment:

 The code uses a loop to gradually adjust the PWM duty cycle when turning the fan on or off.
 This gradual adjustment helps in smoothly transitioning the fan speed, avoiding abrupt changes.
 In practical terms, the hysteresis in fan control system is designed to add stability and prevent the fan from responding to minor temperature fluctuations that might not be significant for the overall system. It improves the system's robustness and efficiency by reducing unnecessary fan speed changes.

 Keep in mind that the specific values used in the code (temperature thresholds, hysteresis range, delays, etc.) should be tuned based on the characteristics of your system and the requirements of your application.

   ![image](/embedded_project_for_learning/nucleo-f446re/Projects/prj06_fan_termo.f/hysteresis-2.jpg)

 

## Components used :

  * STM32F446RE Microcontroller
  * BMP180 module - pressure and temperature sensor
  * 5V DC Fan
  * I2C Serial Interface 1602 (16x2 LCD display module)

## How to build

Run this command:

    ./run.sh compile_only tempreture_contoll NO

## How to flash

You need to install OpenOCD and GDB in your system. Then:

    ./run.sh flash

## How to monitor

You need to install "picocom" in your system. Then:

    ./run.sh monitor

## datasheet

   BMP180 module datasheet: 
    [link](https://cdn-shop.adafruit.com/datasheets/BST-BMP180-DS000-09.pdf).

   DC fan 5v datasheet: 
    [Download PDF](embedded_project_for_learning/nucleo-f446re/Projects/prj06_fan_termo.f/DC_FAN_5v.pdf)


   lcd_I2C 16*2 datasheet: 
    [Download PDF](embedded_project_for_learning/nucleo-f446re/Projects/prj06_fan_termo.f/I2C-LCD-interface.pdf)



#wiring

  |pin|description|
  |-|-|
  |I2C1_SCL  BMP180| PB8 |
  |I2C1_SDA BMP180|PB9 |
  |I2C2_SCL LCD Desplay | PB10 |
  |I2C2_SDA LCD Desplay|PC12 |
  PWM output | connected to PA8|
  GND | GROUND|
  VCC LCD Desplay| power supply → 5v|
  VCC BMP180| power supply → 3.3v|
  VCC DC Fan| power supply → 5v |


## Requirements

* CMake (for linux users : sudo apt install cmake)
* Make 
* gcc-arm-none-eabi
* openOCD
* GDB


 ## Installation

 To install the project, follow these steps:

  1. Clone the repository
  2. Open the project in your preferred IDE
  3. Compile and upload the code to the NUCLEO_F446RE microcontroller

### block diagram 

 ![image](doc/graph.jpg)

### Images & gif

  ![image](doc/image1.jpg)

  ![image](doc/image2.jpg)

  ![Animated GIF](doc/video.gif)

