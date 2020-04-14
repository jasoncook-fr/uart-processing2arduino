import processing.serial.*;
Serial myPort;  // Create object from Serial class

import controlP5.*;

ControlP5 cp5;

int LedAblink = 0;
int LedBblink = 0;
int LedCblink = 0;
int LedDblink = 0;
int LedEblink = 0;
int picoBuckA = 0;
int picoBuckB = 0;
int picoBuckC = 0;

boolean toggleValueA = false;
boolean toggleValueB = false;
boolean toggleValueC = false;
boolean toggleValueD = false;
boolean toggleValueE = false;

int LedAtoggle = 0;
int LedBtoggle = 0;
int LedCtoggle = 0;
int LedDtoggle = 0;
int LedEtoggle = 0;

byte out[] = new byte[14];
byte prevOut[] = new byte[14];


void setup() {
  size(700, 400);
  noStroke();

  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, "/dev/ttyACM0", 9600);  

  cp5 = new ControlP5(this);

  cp5.addSlider("LedAblink").setPosition(100, 50).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("LedBblink").setPosition(100, 70).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("LedCblink").setPosition(100, 90).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("LedDblink").setPosition(100, 110).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("LedEblink").setPosition(100, 130).setSize(300, 16).setRange(0, 254);

  cp5.addSlider("picoBuckA").setPosition(100, 150).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("picoBuckB").setPosition(100, 170).setSize(300, 16).setRange(0, 254);
  cp5.addSlider("picoBuckC").setPosition(100, 190).setSize(300, 16).setRange(0, 254);

  cp5.addToggle("toggleValueA")
    .setPosition(20, 50)
    .setSize(50, 16)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueB")
    .setPosition(20, 70)
    .setSize(50, 16)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueC")
    .setPosition(20, 90)
    .setSize(50, 16)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueD")
    .setPosition(20, 110)
    .setSize(50, 16)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueE")
    .setPosition(20, 130)
    .setSize(50, 16)
    .setMode(ControlP5.SWITCH)
    ;
}

void draw() {


  if (toggleValueA ==true) {
    LedAtoggle=1;
  } else {
    LedAtoggle=0;
  }
  if (toggleValueB ==true) {
    LedBtoggle=1;
  } else {
    LedBtoggle=0;
  }
  if (toggleValueC ==true) {
    LedCtoggle=1;
  } else {
    LedCtoggle=0;
  }
  if (toggleValueD ==true) {
    LedDtoggle=1;
  } else {
    LedDtoggle=0;
  }
  if (toggleValueE ==true) {
    LedEtoggle=1;
  } else {
    LedEtoggle=0;
  }  

  out[0] = byte(LedAblink);
  out[1] = byte(LedBblink);
  out[2] = byte(LedCblink);
  out[3] = byte(LedDblink);
  out[4] = byte(LedEblink);
  out[5] = byte(LedAtoggle);
  out[6] = byte(LedBtoggle);
  out[7] = byte(LedCtoggle);
  out[8] = byte(LedDtoggle);
  out[9] = byte(LedEtoggle);
  out[10] = byte(picoBuckA);
  out[11] = byte(picoBuckB);
  out[12] = byte(picoBuckC);
  out[13] = byte(255);

  for (int i = 0; i < 13; i++)
  {
    if (out[i] != prevOut[i])
    {
      myPort.write(out);
      prevOut[i] = out[i];
      println(out[2]);
      delay(100);
    }
  }
}
