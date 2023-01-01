//
//  ContentView.swift
//  Bloom
//
//  Created by Gerardo on 10/10/21.
//

import SwiftUI


struct MainView: View {

    //@State private var startLocation: CGPoint?
    //@State private var location: CGPoint?
     @State private var showModal = false
     @State var value: CGFloat

    @EnvironmentObject var bleManager : BLEManager
    

    @Binding  var showConnections:Bool
    @Binding  var showAudio:Bool
    @Binding  var showAnimation:Bool
    @Binding  var chosenMode:String
    @Binding  var isConnected: Bool
    let radius: CGFloat = 100
    var diameter: CGFloat{
        radius * 2
    }
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: backgroundGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
                //.ignoresSafeArea()
            
            VStack{
                //Spacer()
                HStack{
                    Spacer()
                    
                    //Button for checking connections
                    Button(action: {
                        showConnections = true
                    }, label: {
                        
                        Text("Connections")
                            .font(.title3)
                        
                    })
                        .foregroundColor(Color(red: 20/255, green: 40/255, blue: 100/255))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    if (isConnected == false){
                        Button(action: {
                            print("NOPE")
                        }, label:{
                            Image(systemName: "togglepower")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height:40)
                            
                        })
                            .padding()
                            .foregroundColor(Color(red: 0/255, green: 0/255, blue: 0/255))
                    }
                    
                    else if(chosenMode == "OFF"){
                        Button(action: {
                            chosenMode = "OFF"
                            self.bleManager.sendAnimation(selectedmode: chosenMode)
                            print("powering on")
                        }, label:{
                            Image(systemName: "togglepower")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height:40)
                            
                        })
                            .padding()
                            .foregroundColor(Color(red: 50/255, green: 0/255, blue: 100/255))

                    }
                    else{
                        Button(action: {
                            chosenMode = "OFF"
                            self.bleManager.sendAnimation(selectedmode: chosenMode)
                            print("powering off")
                        }, label:{
                            Image(systemName: "togglepower")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height:40)
                            
                        })
                            .padding()
                    }
                    
                    
                }
                //Spacer()
                Spacer()
                
                //Divider()
                    //.frame(width:300)
                   // .scaleEffect(0.6)
                
                
                HStack{
                    Spacer()
                    Text("Set Modes")
                        .font(.title)
                        .foregroundColor(Color(red:190/255,green:240/255,blue:180/255))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
                
                
                HStack{
                    Spacer()
                    //Spacer()
                    //Spacer()
                    
                    if(isConnected){
                        Button(action:{
                            showAudio = true
                            print("Look at audio visualizers")
                        }, label: {
                            VStack{
                                Image(systemName: "globe.asia.australia")
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                                Text("Audio Visualizer")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                            }
                        })
                            .frame(width:140 , height:140)
                            .background(Color(red: 10/255, green: 140/255, blue: 229/255))
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                        Button(action:{
                            showAnimation = true
                            print("Choosing between basics")
                        }, label: {
                            VStack{
                                Image(systemName: "globe.asia.australia")
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                                Text("Animations")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                            }
                        })
                            .frame(width:140 , height:140)
                            .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    
                    //NEED TO ADD Capability in circuit 
                    // else{
                    //     Button(action:{
                    //         print("NOPE")
                    //     }, label: {
                    //         VStack{
                    //             Image(systemName: "globe.asia.australia")
                    //                 .resizable()
                    //                 .padding()
                    //                 .scaledToFit()
                    //                 .frame(width: 110, height: 110)
                    //                 .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                    //             Text("Audio Visualizer")
                    //                 .font(.subheadline)
                    //                 .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                    //         }
                    //     })
                    //         .frame(width:140 , height:140)
                    //         .background(Color(red: 10/255, green: 140/255, blue: 229/255))
                    //         .cornerRadius(20)
                    //         .frame(maxWidth: .infinity, alignment: .leading)
                    //         .opacity(0.5)
                        
                    //     Button(action:{
                    //         print("NOPE")
                    //     }, label: {
                    //         VStack{
                    //             Image(systemName: "globe.asia.australia")
                    //                 .resizable()
                    //                 .padding()
                    //                 .scaledToFit()
                    //                 .frame(width: 110, height: 110)
                    //                 .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                    //             Text("Animations")
                    //                 .font(.subheadline)
                    //                 .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                    //         }
                    //     })
                    //         .frame(width:140 , height:140)
                    //         .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                    //         .cornerRadius(20)
                    //         .frame(maxWidth: .infinity, alignment: .trailing)
                    //         .opacity(0.5)
                    // }
                    
                    Spacer()
                }
                
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            
            /*
            if startLocation != nil{
                
                //color circle
                Circle()
                    .frame(width: diameter, height: diameter)
                    .position(startLocation!)
                
                //cursor circle
                
                
                Circle()
                    .frame(width: 50, height: 50)
                    .position(location!)
                    .foregroundColor(.white)
                 
                 
            }
            */
            
            
            VStack{
                Spacer()
                Spacer()
                
                if(isConnected){
                    Button(action:{
                        showModal = true
                        print("Colour Wheel weee")
                    }, label: {
                        VStack{
                            Image(systemName: "globe.asia.australia")
                                .resizable()
                                .padding()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                            Text("Custom Color")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                        }
                    })
                        .frame(width:140 , height:140)
                        .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                        .cornerRadius(20)
                }
                else{
                    Button(action:{
                        print("NOPE")
                    }, label: {
                        VStack{
                            Image(systemName: "globe.asia.australia")
                                .resizable()
                                .padding()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                            Text("Custom Color")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                        }
                    })
                        .frame(width:140 , height:140)
                        .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                        .cornerRadius(20)
                        .opacity(0.5)
                        
                }

                Spacer()
                
            }
            PickerView(value: $value, isShowing: $showModal)
            Spacer()
            
        }

        //.statusBar(hidden:true)
        //.gesture(dragGesture)
        
    }
    
    
    /*
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0)
            .onChanged{ val in
                if startLocation == nil{
                    startLocation = val.location
                }
                let distanceX = val.location.x - startLocation!.x
                let distanceY = val.location.y-startLocation!.y
                
                let dir = CGPoint(x: distanceX, y: distanceY)
                
                var distance = sqrt(distanceX*distanceX + distanceY*distanceY)
                
                if distance < radius{
                    location = val.location
                }
                else{
                    let clampedX = dir.x/distance*radius
                    let clampedY = dir.y/distance*radius
                    location = CGPoint(x:startLocation!.x + clampedX, y: startLocation!.y + clampedY)
                    distance = radius
                    
                }
                if distance == 0{ return}
                    
                var angle = Angle(radians: -Double(atan(dir.y/dir.x)))
                
                if dir.x < 0 {
                    angle.degrees += 180
                }
                else if dir.x > 0 && dir.y > 0{
                    angle.degrees += 360
                }
                print("Degrees:",angle.degrees)
                
                let hue = angle.degrees/360
                
                let saturation = Double(distance / radius)
                //print("hue: \(hue) saturation: \(saturation)")
                
            }
            .onEnded { val in
                startLocation = nil
                location = nil
            }
            } */
    }



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(value:(0.9), showConnections:.constant(false), showAudio: .constant(false), showAnimation: .constant(false), chosenMode: .constant("OFF"),isConnected: .constant(false))
    }
}
