# Bloom
Current development of a BLE Application utilizing Swift UI. This app is meant to utilize the central manager to connec to an HM-10 BLE module and an Arduino in order to control a strip of WS2812B lights

# General Information
This project has been in the making for two years as an introduction to Arduino Microcontrollers, Bluetooth Low Energy, and Swift. We utilize the Bloom app in order to tell the arduino which mode we want the microcontroller to be in so that the lights display the desired animation. When in audio visualizer, we connect our audio source to an attached bluetooth chip (MH-M28) to read the audio and the arduino then reads the audio frequencies to create an audio visualizer using the connected LED lights. Additionally, we take use of the MH-M28s' output jack to connect an external speaker to listen to the audio being played. 

A timeline of my improvements and steps in this journey can be found [in this twitter thread](https://twitter.com/PunaticGerry/status/1292268597901811712?s=20) and **further information will be provided below**.

 ***Videos of the final product can also be found in the twitter thread***
 
 
 ## Steps and Resources
  After having finished my [Blynk Audio Visualizer project](https://github.com/Gcerpa01/Blynk-Audio-Visualizer) I began to hit some issues during setup due to certain WiFis being locked by an additional user account(University Campus WiFi for instance), so I began to look for tutorials on utilizing BLE to control the arduino's mode. I first began by following the following tutorials to learn how to communicate with an HM-10 BLE Module:

1. [Makers Portal] (https://makersportal.com/blog/2019/10/14/bluetooth-module-with-arduino)
2. [Instructables] (https://www.instructables.com/WS2812-controlled-with-Bluetooth-and-Arduino)
3. 
