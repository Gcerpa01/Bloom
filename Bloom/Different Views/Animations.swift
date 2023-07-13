//
//  Animations.swift
//  Bloom
//
//  Created by Gerardo on 11/18/21.
//

import SwiftUI

struct Animations: View { 
    @Binding var status:Bool
    @Binding var chosenMode:String
    @EnvironmentObject var bleManager : BLEManager

    var body: some View {
            ZStack{
                
                LinearGradient(gradient: backgroundGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Button(action: {
                            status = false
                        }, label: {
                            
                            HStack(spacing:-25){
                                Image(systemName: "chevron.backward")
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text("Back")
                                    .padding()
                                    .scaledToFit()
                                    .font(.system(size: 20))
                
                            }
                        })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(red: 20/255, green: 40/255, blue: 100/255))

                        
                        
                        
                    }
                    
                    Spacer()
                    
                    
                    HStack{
                        Spacer()
                        Text("Animations")
                            .font(.title)
                            .foregroundColor(Color(red:190/255,green:240/255,blue:180/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    }
                    
                    
                    HStack{
                        Spacer()

                        
                        Button(action:{
                            chosenMode = "PRD"
                            self.bleManager.sendAnimation(selectedmode: chosenMode)
                            print("Play pride")
                        }, label: {
                            VStack(alignment: .center){
                                Image(systemName: "globe.asia.australia")
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                                
                                Text("Pride")
                                    .font(.subheadline)
                                    .frame(alignment:.center)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
    
                            }
                        })
                            .frame(width:140 , height:160)
                            .background(Color(red: 10/255, green: 140/255, blue: 229/255))
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        Button(action:{
                            
                            print("Pacifica")
                        }, label: {
                            VStack(alignment:.center){
                                Image(systemName: "globe.asia.australia")
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                                Text("Pacifica")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))

                            }
                            
                        })
                            .frame(width:140 , height:160)
                            .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                            // .background(Color(red: 10/255, green: 140/255, blue: 229/255))
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Spacer()
                    }
                    
                    
                    Spacer()
                    //Spacer()
                    
                    VStack(){
                        
                    
                        Button(action:{
                            print("Light Spots")
                        }, label: {
                            VStack(alignment: .center){
                                Image(systemName: "globe.asia.australia")
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(Color(red: 180/255, green: 190/255, blue: 230/255))
                                
                                Text("Light")
                                    .font(.subheadline)
                                    .frame(alignment:.center)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                                Text("Spots")
                                    .font(.subheadline)
                                    .frame(alignment:.center)
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 255/255))
                                
                            }
                        })
                            .frame(width:140 , height:160)
                            .background(Color(red: 20/255, green: 120/255, blue: 190/255))
                            // .background(Color(red: 10/255, green: 140/255, blue: 229/255))
                            .cornerRadius(20)
                            //.frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        //Spacer()
                        
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    //Spacer()
                }
            
            }
       
        }

}

struct Animations_Previews: PreviewProvider {
    static var previews: some View {
        Animations(status: .constant(true), chosenMode: .constant("OFF"))
    }
}
