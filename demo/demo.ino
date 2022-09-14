//  MCP panel stand-alone demo
//  By: Paul van Dinther

//We always have to include the library
#include "LedControl.h"
#include "encoder.h"

#define DEBOUNCE 2

//  Segmented displays
#define MAX7219CS 22  //  segmented display CS (load) yellow
#define MAX7219CLK 23 //  segmented display CLK (clock) green
#define MAX7219DIN 24 //  segmented display DIN (Data in) black

//  LED's
#define LED1_GREEN 11 //  green LED
#define LED1_RED   12 //  red LED

#define LED2_GREEN 47 //  green LED
#define LED2_RED   46 //  red LED

#define LED3_GREEN 49 //  green LED
#define LED3_RED   48 //  red LED

#define LED4_GREEN 51 //  green LED
#define LED4_RED   50 //  red LED

//  Switches
#define SW1 13        //  switch 
#define SW2 53        //  switch

//  Push buttons
#define PB1_SW  41    //  push button 
#define PB1_LED 40    //  green LED

#define PB2_SW  43    //  push button
#define PB2_LED 42    //  green LED

#define PB3_SW  45    //  push button 
#define PB3_LED 44    //  green LED

#define PB4_SW  39    //  push button
#define PB4_LED 38    //  green LED

#define PB5_SW  37    //  push button 
#define PB5_LED 36    //  red LED

//  Encoders
//  course
#define ENC1A 7       //  encoder A
#define ENC1B 8       //  encoder B
#define ENC1S 6       //  push button

//  speed
#define ENC2A 4       //  encoder A
#define ENC2B 5       //  encoder B
#define ENC2S 3       //  push button

//  heading
#define ENC3A 2       //  encoder A
#define ENC3B 15      //  encoder B
#define ENC3S 14      //  push button

//  vertical speed
#define ENC4A 16      //  encoder A
#define ENC4B 17      //  encoder B
#define ENC4S 18      //  not used

//  altitude
#define ENC5A 19      //  encoder A
#define ENC5B 20      //  encoder B
#define ENC5S 21      //  push button

//  Selector switches
#define SEL0 A0       //  5 position selector switch using voltage divider


/*
 Now we need a LedControl to work with.
 ***** These pin numbers will probably not work with your hardware *****
 pin 12 is connected to the DataIn 
 pin 11 is connected to the CLK 
 pin 10 is connected to LOAD 
 ***** Please set the number of devices you have *****
 But the maximum default of 8 MAX72XX wil also work.
 */
LedControl lc=LedControl(MAX7219DIN,MAX7219CLK,MAX7219CS,3);
Encoder encoder1 = Encoder(ENC1A, ENC1B, ENC1S, 235); 
Encoder encoder2 = Encoder(ENC2A, ENC2B, ENC2S, 210);
Encoder encoder3 = Encoder(ENC3A, ENC3B, ENC3S, 055);
Encoder encoder4 = Encoder(ENC4A, ENC4B, ENC4S, 0);
Encoder encoder5 = Encoder(ENC5A, ENC5B, ENC5S, 27);

byte mode= 10;
byte brightness = 1;
bool caution = true;

/* we always wait a bit between updates of the display */
unsigned long lastTime= millis();

void shownum(byte address, unsigned long n, byte start_digit, byte end_digit, bool leading_zeros){
  unsigned long k=n;
  byte blank=0;
  for(int i=start_digit;i<end_digit;i++){
    if(blank){
      if (leading_zeros)
        lc.setDigit(address,i,0,false);
      else
        lc.setRow(address,i,0x00);
    }else{
      lc.setDigit(address,i,k%10,false);
    }
    k=k/10;
    if(k==0){blank=1;}
  }
}

void showCRS(int n){
  while (n > 360){
    n =- 360;
  }
  while (n < 0){
    n =+ 360;
  }
  shownum(0, n, 5, 8, true);
}

void showSPD(int n, bool mach = false, bool ias = false){
  if (n < 0){ n = 0;}
  shownum(0, n, 1, 4, false);
  lc.setLed(0, 0, 1, mach);
  lc.setLed(0, 0, 4, ias);
}

void showHDG(int n){
  while (n > 360){
    n =- 360;
  }
  while (n < 0){
    n =+ 360;
  }
  shownum(1, n, 5, 8, true);
}

void showVS(int n){
  shownum(1, abs(n), 0, 4, false);
  lc.setLed(1, 4, 7, (n < 0));
}

void showALT(int n){
  if (n < 0){ n = 0;}
  shownum(2, n, 3, 8, false);
}

void showMode(int n){
  if (n < 0){ n = 0;}
  shownum(2, n, 0, 3, false);
}

/* 
 This time we have more than one device. 
 But all of them have to be initialized 
 individually.
 */
void setup() {
  //Serial.begin(9600); // open the serial port at 9600 bps:

  pinMode(SW1, INPUT_PULLUP);
  pinMode(SW2, INPUT_PULLUP);

  pinMode(LED1_GREEN, OUTPUT);
  pinMode(LED1_RED, OUTPUT);
  pinMode(LED2_GREEN, OUTPUT);
  pinMode(LED2_RED, OUTPUT);
  pinMode(LED3_GREEN, OUTPUT);
  pinMode(LED3_RED, OUTPUT);
  pinMode(LED4_GREEN, OUTPUT);
  pinMode(LED4_RED, OUTPUT);

  pinMode(PB1_SW, INPUT_PULLUP);
  pinMode(PB1_LED, OUTPUT);
  pinMode(PB2_SW, INPUT_PULLUP);
  pinMode(PB2_LED, OUTPUT);
  pinMode(PB3_SW, INPUT_PULLUP);
  pinMode(PB3_LED, OUTPUT);
  pinMode(PB4_SW, INPUT_PULLUP);
  pinMode(PB4_LED, OUTPUT);  
  pinMode(PB5_SW, INPUT_PULLUP);
  pinMode(PB5_LED, OUTPUT);
 
  //we have already set the number of devices when we created the LedControl
  int devices=lc.getDeviceCount();
  
  //we have to init all devices in a loop
  for(int address=0;address<devices;address++) {
    /*The MAX72XX is in power-saving mode on startup*/
    lc.shutdown(address,false);
    /* Set the brightness to a medium values */
    lc.setIntensity(address,brightness + address);
    /* and clear the display */
    lc.clearDisplay(address);
  }

digitalWrite(PB5_LED, caution);

  showCRS(encoder1.getValue()); 
  showSPD(encoder2.getValue(), false, true);
  showHDG(encoder3.getValue());
  showVS(encoder4.getValue());
  showALT(encoder5.getValue()*100);
  showMode(mode);  
}

void loop() { 
  if (encoder1.update(DEBOUNCE)){
    while (encoder1.getValue() < 0){
      encoder1.setValue(encoder1.getValue() + 360);
    }
    while (encoder1.getValue() > 359){
      encoder1.setValue(encoder1.getValue() - 360);
    }
    showCRS(encoder1.getValue());
  }
  if (encoder2.update(DEBOUNCE)){
    if (encoder2.getValue() < 0){
      encoder2.setValue(0);
    }    
    showSPD(encoder2.getValue(), false, true);
  }
  if (encoder3.update(DEBOUNCE)){
    while (encoder3.getValue() < 0){
      encoder3.setValue(encoder3.getValue() + 360);
    }
    while (encoder3.getValue() > 359){
      encoder3.setValue(encoder3.getValue() - 360);
    }
    showHDG(encoder3.getValue());
  }
  if (encoder4.update(DEBOUNCE)){
    showVS(encoder4.getValue()*50);
  }
  if (encoder5.update(DEBOUNCE)){
    if (encoder5.getValue() < 0){
      encoder5.setValue(0);
    }
    showALT(encoder5.getValue()*100);
  }  
  
  int sel1 = round(analogRead(SEL0) / 210); //converts analog input to discrete selection values
  if (sel1 != mode){
    if (sel1==0){
      lc.setIntensity(0,0);
      lc.setIntensity(1,0);
      lc.setIntensity(2,0);
    }
    if (sel1==1){
      lc.setIntensity(0,1);
      lc.setIntensity(1,2);
      lc.setIntensity(2,3);
    }
    if (sel1==2){
      lc.setIntensity(0,3);
      lc.setIntensity(1,5);
      lc.setIntensity(2,6);
    }
    if (sel1==3){
      lc.setIntensity(0,5);
      lc.setIntensity(1,7);
      lc.setIntensity(2,9);
    }        
    if (sel1==4){
      lc.setIntensity(0,7);
      lc.setIntensity(1,12);
      lc.setIntensity(2,15);
    }    
    
    showMode(sel1);
    mode = sel1;
  }

  if (!digitalRead(PB1_SW)){
    digitalWrite(PB1_LED, true);
    digitalWrite(PB2_LED, false);
    digitalWrite(PB3_LED, false);
    digitalWrite(PB4_LED, false);
  }

  if (!digitalRead(PB2_SW)){
    digitalWrite(PB1_LED, false);
    digitalWrite(PB2_LED, true);
    digitalWrite(PB3_LED, false);
    digitalWrite(PB4_LED, false);
  }

  if (!digitalRead(PB3_SW)){
    digitalWrite(PB1_LED, false);
    digitalWrite(PB2_LED, false);
    digitalWrite(PB3_LED, true);
    digitalWrite(PB4_LED, false);
  }  

  if (!digitalRead(PB4_SW)){
    digitalWrite(PB1_LED, false);
    digitalWrite(PB2_LED, false);
    digitalWrite(PB3_LED, false);
    digitalWrite(PB4_LED, true);
  }
    
  if (!digitalRead(PB5_SW)){
    caution = !caution;
    digitalWrite(PB5_LED, caution);
    delay(300);
  }

  digitalWrite(LED1_GREEN,digitalRead(SW1));
  bool state = digitalRead(SW2);
  digitalWrite(LED2_GREEN, state);
  digitalWrite(LED3_GREEN, state);
  digitalWrite(LED4_GREEN, state);
  digitalWrite(LED2_RED, !state);
  digitalWrite(LED3_RED, !state);
  digitalWrite(LED4_RED, !state);  
}
