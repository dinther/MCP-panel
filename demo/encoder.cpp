//  Basic encoder class
//  By: Paul van Dinther

#include "Arduino.h"
#include "encoder.h"

Encoder::Encoder(int pinA, int pinB, int pinS, int value) {
  pinMode(pinA, INPUT_PULLUP);
  pinMode(pinB, INPUT_PULLUP);
  pinMode(pinS, INPUT_PULLUP);
  _pinA = pinA;
  _pinB = pinB;
  _pinS = pinS;
  _encoder_A = false;
  _encoder_B = false;
  _encoder_S = false;
  _value = value;
  _down = false;
  _lastTime = millis();
}

bool Encoder::update(byte debounce = 2){
  unsigned long currentTime = millis();
  int old_value = _value;
  bool down = _down;
  if(currentTime >= (_lastTime + debounce)){
    _lastTime = currentTime;
    bool encoder_A = digitalRead(_pinA);    // Read encoder pins
    bool encoder_B = digitalRead(_pinB);
    
    if(encoder_A != _encoder_A){
      // A changed
      if(encoder_A != encoder_B) {
        // but B has not yet changed. CW
        _value--;
      }
    }

    if(encoder_B != _encoder_B){
      // B changed
      if(encoder_B != encoder_A) {
        // but A has not yet changed. CCW
        _value++;
      }
    }

    _down = digitalRead(_pinS);

    _encoder_A = encoder_A;
    _encoder_B = encoder_B;
  }
  return _value != old_value;// || down != _down;
}

int Encoder::getValue(){
  return _value;
}

void Encoder::setValue(int value){
  _value = value;
}

bool Encoder::getDown(){
  return _down;
}
