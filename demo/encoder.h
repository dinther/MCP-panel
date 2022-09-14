//  Basic encoder class
//  By: Paul van Dinther

#ifndef Encoder_h
#define Encoder_h
#include "Arduino.h" 
class Encoder {
public:
  Encoder(int pinA, int pinB, int pinS, int value);
  bool update(byte debounce);
  int getValue();
  void setValue(int value);
  bool getDown();
private:
  int _pinA;
  int _pinB;
  int _pinS;
  unsigned long _lastTime;
  bool _encoder_A;
  bool _encoder_B;
  bool _encoder_S;
  int _value;
  bool _down;
};
#endif
