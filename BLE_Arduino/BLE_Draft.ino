
/* Gerardo Cerpa
 *
 * Utilized David Wang's code to read audio input from a 3.5 mm cable
 * so huge amount of gratitude to him.
 * The audio input is then used to animate an LED stip based
 * on the pitch and volume of the music.
 *
 *Also utilized Mark Wang's Pride 2015 animation, all credit goes to him
 *for that section of code and gratitude for an introduction
 *to LEDs
 *
 */

#include <FastLED.h>
#include "audioVisualizer.h"

/* -------------------------------- */
/*  ---------- BLE Control -------- */
/*  ------------------------------ */
#include <SoftwareSerial.h>
SoftwareSerial ble(9,10);
char select_code[4] = "OFF";

/*  ------------------------------ */
/*  ------- Audio Visualizer ----- */
/*  ------------------------------ */
int analogPin = A0; // MSGEQ7 OUT
int strobePin = 2; // MSGEQ7 STROBE //D1 Application // D5 Test
int resetPin = 3                                           ; // MSGEQ7 RESET //D0 Application  // D6 Test
int spectrumValue[7];
// MSGEQ7 OUT pin produces values around 50-80
// when there is no input, so use this value to
// filter out a lot of the chaff.
int filterValue = 80;
int brightness = 50;

/* -------------------------------- */
/*  ------- Control Variables ----- */
/*  ------------------------------ */
//Control variables to help dictate the mode running
int lightStatus = 0;
//Create led object
Color led;

void setup() {
Serial.begin(9600);
ble.begin(9600);


delay(100);


sendCommand("AT+NAME?");
delay(100);
sendCommand("AT+NAMEBLOOMHUB");
delay(100);

sendCommand("AT+ROLE0"); //role as peripheral; 1 for central
delay(100);

sendCommand("AT+UUID0xFFE00"); //uuid
delay(100);

sendCommand("AT+CHAR0xFFE01"); //uuid chara
delay(100);

/*  ------------------------------ */
/*  -------- Set Up LEDS --------- */
/*  ------------------------------ */
led.ledSetup();

/*  ------------------------------ */
/*  ---- LED Visualizer Setup ---- */
/*  ------------------------------ */
//Setup the pins for reading from MSGEQ7
randomSeed(analogRead(A0));
// Read from MSGEQ7 OUT
pinMode(analogPin, INPUT);
// Write to MSGEQ7 STROBE and RESET
pinMode(strobePin, OUTPUT);
pinMode(resetPin, OUTPUT);
// Set analogPin's reference voltage
//analogReference(DEFAULT); // 5V

// Set startup values for pins
digitalWrite(resetPin, LOW);
digitalWrite(strobePin, HIGH);

}

void sendCommand(const char* command){
  Serial.print("Order sent");
  Serial.println(command);
  ble.println(command); //send command
  delay(100);

  char reply[100];

  int i = 0;

  while(ble.available()){ //if hm10 is available read back from it
    reply[i] = ble.read();
    i+=1;
  }
  reply[i] = '\0';

  Serial.print(reply);
  Serial.println("Reply Success");
}


//Create an array of different methods to dictate the mode that will be
//running with the program
typedef void(*Spectremodes[])();
Spectremodes pos = {off,audio,pride,sparkle_AudioI};

void selectMode(){
  if(strcmp(select_code,"OFF") == 0){
    lightStatus = 0;
  }
  else if (strcmp(select_code,"WAV")==0){
    lightStatus = 1;
  }
  else if (strcmp(select_code,"PRD")==0){
    lightStatus = 2;
  }
  else if (strcmp(select_code,"SA1")==0){
    lightStatus = 3;
  }
}


void chooseMode(){
  char reply[4];
  int i = 0;
  while (ble.available()) {
    reply[i] = ble.read();
    if(reply[i] != 'X'){
      select_code[i] = reply[i];
    }
    i += 1;
  }
  //end the string
  reply[i] = '\0';
  if(strlen(reply) > 0){
    //Serial.println(reply); //verify code received 
    //Serial.println(select_code); //verify what's used 
  }
}

void loop() {
  chooseMode();
  selectMode();
  //Serial.println(lightStatus);
  pos[lightStatus]();
  // put your main code here, to run repeatedly:
}

//Runs the audio visualizer function to display
//an audio spectrum across the lights
void audio(){
  Serial.println("AVI");

  digitalWrite(resetPin, HIGH);
  digitalWrite(resetPin, LOW);
  // Get all 7 spectrum values from the MSGEQ7
  for (int i = 0; i < 7; i++)
  {
    digitalWrite(strobePin, LOW);
    delayMicroseconds(30); // Allow output to settle
 
    spectrumValue[i] = analogRead(analogPin);
 
    // Constrain any value above 1023 or below filterValue
    spectrumValue[i] = constrain(spectrumValue[i], filterValue, 1023);
 
 
    // Remap the value to a number between 0 and 255
    spectrumValue[i] = map(spectrumValue[i], filterValue, 1023, 0, 255);
 
    // Remove serial stuff after debugging
     //Serial.print(spectrumValue[i]);
    // Serial.print(" ");
     digitalWrite(strobePin, HIGH);
   }
  //Serial.println("");
  Color audioLights;
  audioLights.animate(spectrumValue);
  
}

//Turns all leds off
void off() {
 Serial.println("Off");
  
  do{                             //Start of a loop
    brightness = brightness - 10;           //Subtract 10 from the bright variable and save it
    FastLED.setBrightness(brightness);  //Set LED strip Brightness to the value storged in "Bright"
    FastLED.show();                 //Update LED strip
    delay(10);                      //Wait for 20ms
    }while(brightness > 0);             //Go back to start of the loop if Bight is bigger then 0
    FastLED.clear();
    brightness = 50;                    //turn of LED strip
    FastLED.setBrightness(brightness); 
    FastLED.show();
}

//Changes animation to sample provided in FastLED library
void pride(){
  
    Color pride;
    pride.pridefx();
    Serial.println("Pride is on");
    FastLED.setBrightness(brightness); 
    FastLED.show();
  
}


void sparkle_AudioI(){
  digitalWrite(resetPin, HIGH);
  digitalWrite(resetPin, LOW);
  // Get all 7 spectrum values from the MSGEQ7
  for (int i = 0; i < 7; i++)
  {
    digitalWrite(strobePin, LOW);
    delayMicroseconds(30); // Allow output to settle
 
    spectrumValue[i] = analogRead(analogPin);
 
    // Constrain any value above 1023 or below filterValue
    spectrumValue[i] = constrain(spectrumValue[i], filterValue, 1023);
 
 
    // Remap the value to a number between 0 and 255
    spectrumValue[i] = map(spectrumValue[i], filterValue, 1023, 0, 255);
 
    // Remove serial stuff after debugging
    //Serial.print(spectrumValue[i]);
    //Serial.print(" ");
    digitalWrite(strobePin, HIGH);
   }
  Serial.println("Sparkle");
  Color audioLights;
  audioLights.sparkleAudioI(spectrumValue);
}
