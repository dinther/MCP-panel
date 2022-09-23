# MCP-panel

![image](https://user-images.githubusercontent.com/1192916/190020247-507466dd-918f-47a0-b019-b9db686d0157.png)

3D print your own MCP panel for flight simulator.

![image](https://user-images.githubusercontent.com/1192916/190311741-e2671a8e-7057-4d50-86a3-c131b47b6a02.png)

Actual printed panels.

![image](https://user-images.githubusercontent.com/1192916/190303993-10bff4c4-5c5f-4b4e-97c5-940528641fc1.png)

## wiring

I wired all switches and encoders to pull the input pin down to ground. This means that the arduino input pins are configured to "INPUT_PULLUP" in mobiflight.

## Hardware used

For convenience I sourced my parts from a local electronics store. Not cheap but I link it here so you can get the details of the parts and source them where you wish.

### Arduino Mega

The one I used is a clone but Mobiflight recognized it without any issues.

![image](https://user-images.githubusercontent.com/1192916/191902870-b5d4bcbd-089a-4f39-a2c9-693b26a8d26a.png)

https://www.jaycar.co.nz/duinotech-mega-2560-r3-board-for-arduino/p/XC4420

### Segmented displays
I used three 8 digit 7 segment displays. They only had red ones but ideally you want white ones.
The panel is designed to accomodate these displays but these parameters can be changed in OpenSCAD.
You only need three outputs for the all the displays as they are linked.

![image](https://user-images.githubusercontent.com/1192916/191902823-da34c0ee-2f59-48e6-b0bc-784838041c6e.png)

Tip: Pick the ones where the two display componets are soldered on straight. I noticed many of these displayed online are crooked. However, I did design in some leeway in the 3D panel to accomodate this.

https://www.jaycar.co.nz/8-digit-7-segment-display-module/p/XC3714

### Tactile push buttons
These momentary pushbuttons have build in LED's in red, green and blue. They are small and cheap and with a 3D printed custom face attached they can show whatever back-lit caption you want. The panel has slots designed for 5 of these buttons that should fit tight.
![image](https://user-images.githubusercontent.com/1192916/191902740-a9109acc-c9fa-4ce0-bd01-daa7ec5b9bbe.png)

https://www.jaycar.co.nz/spst-pcb-mount-tactile-switch-with-green-led/p/SP0621

### Rotary encoder

I actually used two types of encoders and the shafts were slightly different. The 5 panel holes are made to take either type. The encoders also have a push button function But the vertical wheel can not access the push button function. You need 3 inputs per LED.

![image](https://user-images.githubusercontent.com/1192916/191902905-9cfea7e5-0e4f-4883-9c30-0e62887eee89.png)

https://www.jaycar.co.nz/rotary-encoder-with-pushbutton/p/SR1230

### Dual color 3mm LED's

The panel has 4 dual color (Red / Green) LED's. One is used behind a back-lit round label and the other three as Landing wheel indicators. You can actually also get Amber if you turn on both Red and Green. You need two outputs per LED

![image](https://user-images.githubusercontent.com/1192916/191902933-47e61cc0-b694-4c6e-94d7-e3020cf326af.png)

https://www.jaycar.co.nz/tricolour-red-green-orange-3mm-led-4-5-6mcd-round-diffused/p/ZD0249


### Toggle switches

The panel contains two toggle switches. Each switch requiring one input.

![image](https://user-images.githubusercontent.com/1192916/191902965-0f5e1dba-70fa-41f9-bf47-2c3ba546faa8.png)

https://www.jaycar.co.nz/spdt-sub-miniature-toggle-switch-solder-tag/p/ST0300
