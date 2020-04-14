# Multi-Byte usb serial communication from Processing to Arduino

This is a great example of serial communication between processing and arduino. Mutiple bytes are sent and organized. <br />

First upload the code arduino_recv_data.ino to an arduino. Make all necessary connections for LEDs (there's a bunch). When using the interface provided in the Processing code, some of the LEDs will change frequency of blinking while some will fade (PWM). You will find the correct pin numbers to connect your LEDs by examining the arduino code directly.<br />

Next, in Processing, open the code titled processing_send_data.pde <br /> 

# Attention: Library controlP5 is required for processing <br />

Before launching the Processing code make sure that you choose the correct USB port to communicate with (On Linux, in my case it is /dev/ttyUSB0). After installing the controlP5 library you should be ready to go.<br />

Last note. There is a last code example called pretty_processing_send_data.pde<br />
This is the same functionality with added glitter to the interface to make it less bland. 
