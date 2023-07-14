# Bloom
Current development of a BLE Application utilizing Swift UI. This app is meant to utilize the central manager to connect to an ESP32-C3 in order to control a strip of WS2812B lights alongside an ESP32 Devkit V1 and PCM5102.

# General Information
This project has been in the making for three years as an introduction to Arduino Microcontrollers, Bluetooth Low Energy, and Swift. We utilize the Bloom app in order to tell the ESP which mode we want the microcontroller to be in so that the lights display the desired animation. When in audio visualizer, we connect our audio source to an attached bluetooth receiver (ESP32 + PCM5102) to read the audio and the MSGEQ7 then divides the audio frequencies for the ESP32-C3 to create an audio visualizer using the connected LED lights. Additionally, we take use of the PCM5102's output jack to connect an external speaker to listen to the audio being played. 


# Demo
[![Demo](https://img.youtube.com/vi/ml52ldNw_ss/maxresdefault.jpg)](https://youtu.be/ml52ldNw_ss)

A timeline of my improvements and steps in this journey can be found [in this twitter thread] (https://twitter.com/PunaticGerry/status/1292268597901811712?s=20) as well as in this github repro.
**further information will be provided below**.
 
 ---
 ## Steps and Resources
  After having finished my [Blynk Audio Visualizer project](https://github.com/Gcerpa01/Blynk-Audio-Visualizer) I began to hit some issues during setup due to certain WiFis being locked by an additional user account(University Campus WiFi for instance), so I began to look for tutorials on utilizing BLE to control the arduino's mode as I would no longer to depend on any external factor besides the user's source device to communicate with the BLE module
  
### 1. Utilizing BLE

 #### Upgrading to ESP32-C3
 In an effort to make the circuit smaller as well as cheaper and more efficient, I moved over to an ESP32-C3. Rather than needing an Arduino Nano and an HM-10 module, we now only require 1 module, allowing us to have more memory for more commands and customization within our BLE app. The following tutorial proved useful in making this change:
1. [Random Nerds](https://randomnerdtutorials.com/esp32-bluetooth-low-energy-ble-arduino-ide/)


 #### Using an HM-10 Module
 I first began by following the following tutorials to learn how to communicate with an HM-10 BLE Module utilizing apps available in the app store such as LightBlue and BLE Scanner to communicate with the Arduino:
1. [Makers Portal](https://makersportal.com/blog/2019/10/14/bluetooth-module-with-arduino)
2. [Instructables](https://www.instructables.com/WS2812-controlled-with-Bluetooth-and-Arduino)
 
The finished code for the Arduino side can be found in the [**BLE_Arduino**](https://github.com/Gcerpa01/Bloom/tree/main/BLE_Arduino) folder. Please note that the color wheel feature is not compatible when using the HM-10 Module.
 
### 2. Communicating via an App
 Once I finished being able to communicate with the Arduino I then began to look for tutorials on writing BLE applications on iOS. The ones I found helpful were the following:
1. [Adafruit](https://learn.adafruit.com/build-a-bluetooth-app-using-swift-5/communication)
2. [JaredWolff](https://www.jaredwolff.com/the-ultimate-how-to-bluetooth-swift-with-hardware-in-20-minutes/)
3. [NovelBits Part 1](https://novelbits.io/intro-ble-mobile-development-ios/)
4. [NovelBits Part 2](https://novelbits.io/intro-ble-mobile-development-ios-part-2/)

 I do want to note that I ended up subscribing to NovelBits to follow their tutorial a bit more in depth in order to learn to properly connect and communicate with the HM-10 Module but I also added a few free tutorials I found online and listed them first in the list above.
 
Note: This step remained the same when moving to an ESP32-C3, witht the only changes requiring to change the UUID's of the device we are connecting to. 

### 3. Designing the App
 Once I got the fundamentals down, I then went into designing the application to both work and have a UI I myself am proud off and would think is user friendly. I actually started off from scratch in order to create proper Swift Views, Navigation, a Color Wheel(*Note: Not implemented yet on Arduino side*) and once the views were done, I then began implementing the functionality I learned in the previous step to have my UI have implemented functionality. I utilized the following tutorials in order to learn how to build the application:
 1. [Color Wheel - Priva 28](https://github.com/Priva28/SwiftUIColourWheel)
 2. [Custom Color Picker - Haipp](https://youtu.be/dPQM332JOWY)
 3. [Color Slider - Medium - Priva 28](https://priva28.medium.com/making-a-custom-slider-in-swiftui-db440cd6d88c)
 4. [The Complete Guide to NavigationView in SwiftUI - Paul Hudson](https://youtu.be/nA6Jo6YnL9g)
 5. [Building First SwiftUI App - Paul Hudson](https://www.youtube.com/watch?v=aP-SQXTtWhY)
 
 The art for the application was done using both available SF Symbols and Art I made(and am still working on). The files for the application can be found in the [**Bloom**](https://github.com/Gcerpa01/Bloom/tree/main/Bloom) and [**Bloom.xcodeproj**](https://github.com/Gcerpa01/Bloom/tree/main/Bloom.xcodeproj), requiring to have xcode in order to run the applications on your iOS device(currently not on the app store)
 
 ---
 # Schematic
  ## ESP32-C3
 As stated before, in an effort to modify the Arduino and HM-10 circuit, I switched over to an ESP32-C3 to have more memory and have less modules. Additionally, in sake of customizability I also utilized an additional ESP32 and PCM5102 in order to customize the bluetooth audio receiver by utilizing the [ESP32 A2DP Receiver Libaray](https://github.com/pschatzmann/ESP32-A2DP) allowing to create the receiver with an assigned name and output audio using the digital to audio converter chip(PCM5102) with it's included audio jack, while still being able to read the frequencies of the audio being played.
 
 Note: If music visualization is not desired, the ESP32,PCM5102,MSGEQ7 can be removed for a simple LED light controller
 ![New Modular](https://github.com/Gcerpa01/Bloom/blob/ESP32/Schematic%20and%20PCB/Schematic.png?raw=true)
 
 ## Arduino and HM-10
For this project I modified my schematic from my [Blynk Audio Visualizer project](https://github.com/Gcerpa01/Blynk-Audio-Visualizer) to instead utilize an Arduino Nano and adding an HM-10 BLE module, with the final schematic appearing as below:

![Untitled_Artwork](https://user-images.githubusercontent.com/81593072/210277287-b5ef31b9-3f84-4afa-ab45-70813d645f0c.png)


---
#### Caveats
 The project is at a point I'm happy calling it done despite it still needing a few upgrades. I need to work on some of the art for the buttons of the app, as well as enhance the code on the ESP32 side, as to have more animations avaiable in the app. Additionally, this code is exclusive to iOS at the moment given it was written for me and my family and friends to be able to utilize it so working on android alternative is a goal in the long run. 

---
#### Final Thoughts
 I began this project when I was in a dark spot in my life and I ended up finding a hobby I fell in love with. I have gone through multiple iterations for this project and despite it not being perfect it's at a state I am proud of what I have made and feel confident sharing it. I learned a lot about BLE, arduino, app development as well as coding but most importantly I learned about enjoying the journey and having fun with something. I do want to leave this repo updated and available as I want anyone learning or interested in learning these things to have access to this as a learning source. 



