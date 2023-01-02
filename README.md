# Bloom
Current development of a BLE Application utilizing Swift UI. This app is meant to utilize the central manager to connec to an HM-10 BLE module and an Arduino in order to control a strip of WS2812B lights

# General Information
This project has been in the making for two years as an introduction to Arduino Microcontrollers, Bluetooth Low Energy, and Swift. We utilize the Bloom app in order to tell the arduino which mode we want the microcontroller to be in so that the lights display the desired animation. When in audio visualizer, we connect our audio source to an attached bluetooth chip (MH-M28) to read the audio and the arduino then reads the audio frequencies to create an audio visualizer using the connected LED lights. Additionally, we take use of the MH-M28s' output jack to connect an external speaker to listen to the audio being played. 

A timeline of my improvements and steps in this journey can be found [in this twitter thread](https://twitter.com/PunaticGerry/status/1292268597901811712?s=20) and **further information will be provided below**.

 ***Videos of the final product can also be found in the twitter thread***
 
 
 ## Steps and Resources
  After having finished my [Blynk Audio Visualizer project](https://github.com/Gcerpa01/Blynk-Audio-Visualizer) I began to hit some issues during setup due to certain WiFis being locked by an additional user account(University Campus WiFi for instance), so I began to look for tutorials on utilizing BLE to control the arduino's mode as I would no longer to depend on any external factor besides the user's source device to communicate with the BLE module
  
### 1. Utilizing HM-10 Module
 I first began by following the following tutorials to learn how to communicate with an HM-10 BLE Module utilizing apps available in the app store such as LightBlue and BLE Scanner to communicate with the Arduino:
1. [Makers Portal] (https://makersportal.com/blog/2019/10/14/bluetooth-module-with-arduino)
2. [Instructables] (https://www.instructables.com/WS2812-controlled-with-Bluetooth-and-Arduino)
 The finished code for the Arduino side can be found in the [**BLE_Arduino**](https://github.com/Gcerpa01/Bloom/tree/main/BLE_Arduino) folder 
 
### 2. Communicating via an App
 Once I finished being able to communicate with the Arduino I then began to look for tutorials on writing BLE applications on iOS. The ones I found helpful were the following:
1. [Adafruit](https://learn.adafruit.com/build-a-bluetooth-app-using-swift-5/communication)
2. [JaredWolff](https://www.jaredwolff.com/the-ultimate-how-to-bluetooth-swift-with-hardware-in-20-minutes/)
3. [NovelBits Part 1](https://novelbits.io/intro-ble-mobile-development-ios/)
4. [NovelBits Part 2](https://novelbits.io/intro-ble-mobile-development-ios-part-2/)
 I do want to note that I ended up subscribing to NovelBits to follow their tutorial a bit more in depth in order to learn to properly connect and communicate with the HM-10 Module but I also added a few free tutorials I found online and listed them first in the list above.
 

### 3. Designing the App
 Once I got the fundamentals down, I then went into designing the application to both work and have a UI I myself am proud off and would think is user friendly. I actually started off from scratch in order to create proper Swift Views, Navigation, a Color Wheel(*Note: Not implemented yet on Arduino side*) and once the views were done, I then began implementing the functionality I learned in the previous step to have my UI have implemented functionality. I utilized the following tutorials in order to learn how to build the application:
 1. [Color Wheel - Priva 28](https://github.com/Priva28/SwiftUIColourWheel)
 2. [Custom Color Picker - Haipp](https://youtu.be/dPQM332JOWY)
 3. [Color Slider - Medium - Priva 28](https://priva28.medium.com/making-a-custom-slider-in-swiftui-db440cd6d88c)
 4. [The Complete Guide to NavigationView in SwiftUI - Paul Hudson](https://youtu.be/nA6Jo6YnL9g)
 5. [Building First SwiftUI App - Paul Hudson](https://www.youtube.com/watch?v=aP-SQXTtWhY)
 
 The art for the application was done using both available SF Symbols and Art I made(and am still working on). The files for the application can be found in the [**Bloom**](https://github.com/Gcerpa01/Bloom/tree/main/Bloom) and [**Bloom.xcodeproj**](https://github.com/Gcerpa01/Bloom/tree/main/Bloom.xcodeproj), requiring to have xcode in order to run the applications on your iOS device(currently not on the app store)
 

