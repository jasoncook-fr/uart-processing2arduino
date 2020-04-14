#include <SoftwareSerial.h>

SoftwareSerial mySerial(2, 4); // RX, TX

int currentValue = 0;
int values[13] = {};
int numLeds = 5;

int BlinkLeds[] = {8, 9, 10, 11, 12};

unsigned long currentMillis = 0;
unsigned long previousMillis[5] = {};
unsigned long interval[5] = {};

int ledState[5] = {};
bool ledFlag[5] = {};

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Native USB only
  }

  // set the data rate for the SoftwareSerial port
  //mySerial.begin(9600);
  //mySerial.println("Hello, world?");

  for (int i = 0; i < 5; i++)
  {
    pinMode(BlinkLeds[i], OUTPUT);
  }
  pinMode(3, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
}


void loop()
{
  if (Serial.available())
  {
    int incomingValue = Serial.read();

    if (incomingValue == 255)
    {
      int picoBuckValA = values[10];
      int picoBuckValB = values[11];
      int picoBuckValC = values[12];
      analogWrite(3, picoBuckValA);
      analogWrite(5, picoBuckValB);
      analogWrite(6, picoBuckValC);

      currentValue = 0;
      for (int i = 0; i < numLeds; i++)
      {
        interval[i] = values[i];
        interval[i] = map(values[i], 0, 255, 10, 1000);
        interval[i] = constrain(interval[i], 10, 1000);

        int flagVal = i + numLeds;
        ledFlag[i] = values[flagVal];
      }
     /*
            mySerial.println("###################################################");
            mySerial.print("all vals are ");
            for (int i = 0; i < 13; i++)
            {
              mySerial.print(values[i]);
              mySerial.print(",");
            }
            mySerial.println();
            mySerial.print("flag vals are ");
            for (int i = 0; i < 5; i++)
            {
              mySerial.print(ledFlag[i]);
              mySerial.print(",");
            }
            mySerial.println();
            delay(1);
    */
    }
    else
    {
      values[currentValue] = incomingValue;
      currentValue++;
    }
  }
  for (int i = 0; i < numLeds; i++)
  {
    currentMillis = millis();

    if (currentMillis - previousMillis[i] >= interval[i])
    {
      previousMillis[i] = currentMillis;
      if (ledFlag[i] == 0) ledState[i] = LOW;
      else if (ledState[i] == LOW) ledState[i] = HIGH;
      else ledState[i] = LOW;

      digitalWrite(BlinkLeds[i], ledState[i]);
    }
  }
}
