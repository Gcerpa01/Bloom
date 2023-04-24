
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
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

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

BLEServer *pServer;
BLECharacteristic *pCharacteristic;
bool deviceConnected = false;
bool connectTimer = false;
unsigned long currentMillis,prevMillis;
#define SERVICE_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E" // UART service UUID
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_TX "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      if(!deviceConnected){
        currentMillis = millis();
        connectTimer = true;
        Serial.println("Timer started to connect");
      }
      else{
        Serial.println("a device is already paired");
        ESP.restart();
      }
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("Device is not connected");
      pServer->startAdvertising(); // restart advertising after disconnecting
    }
};



class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string rxValue = pCharacteristic->getValue();

      if (rxValue.length() > 0) {
        Serial.println("*********");
        Serial.print("Received Value: ");
        for (int i = 0; i < rxValue.length(); i++) {
          Serial.print(rxValue[i]);
        }
        Serial.println();

        if(!deviceConnected){
          if(rxValue.find("CODE") != -1){
            deviceConnected = true;
            connectTimer = false;
            Serial.println("Successfully paired");
          }
        }
        else{
        
        // Do stuff based on the command received from the app
        if (rxValue.find("OFF") != -1) { 
          lightStatus = 0;
        }
        else if(rxValue.find("WAV") != -1){
          lightStatus = 1;
        }

        else if(rxValue.find("PRD") != -1){
          lightStatus = 2;
        }

        else if(rxValue.find("SA1") != -1){
          lightStatus = 3;
        }
        
        }

        Serial.println();
        Serial.println("*********");
      }
    }
};



void setup() {
  Serial.begin(9600);
  delay(100);


  // Create the BLE Device
  BLEDevice::init("Bloom"); // Give it a name

  // Create the BLE Server
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_TX,
                      BLECharacteristic::PROPERTY_NOTIFY
                    );
                      
  pCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID_RX,
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  pCharacteristic->setCallbacks(new MyCallbacks());

  // Start the service
  pService->start();

  // Start advertising
  pServer->getAdvertising()->start();
  Serial.println("Waiting a client connection to notify...");



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

//Create an array of different methods to dictate the mode that will be
//running with the program
typedef void(*Spectremodes[])();
Spectremodes pos = {off,audio,pride,sparkle_AudioI};

void loop() {
  if(connectTimer){
    if(currentMillis - prevMillis >= 9000){
      Serial.println("Do not connect device");
      connectTimer = false;
      ESP.restart();
    }
  }
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
    delay(10);                      //Wait for 10ms
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