//
//  Connections.swift
//  Bloom
//
//  Created by Gerardo on 11/18/21.
//

import SwiftUI

struct Connections: View {
    @EnvironmentObject var bleManager : BLEManager
   //@ObservedObject var bleManager = BLEManager()

    @State var modeSelect : UInt8 = 255
    
    @Binding var status:Bool
    @Binding var isConnected:Bool
    

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

                    
                    if(bleManager.isSwitchedOn){

                    Image(systemName:"antenna.radiowaves.left.and.right")
                        .padding()
                        .frame(width:100,height:100)
                        .scaledToFit()
                        .font(.system(size: 30))
                    }
                    else{
                        Image(systemName:"antenna.radiowaves.left.and.right.slash")
                            .padding()
                            .frame(width:100,height:100)
                            .scaledToFit()
                            .font(.system(size: 30))
                    }
                    
                }
                //Spacer()
                Text("Available Devices")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity,alignment: .center)
                //Spacer()
                
                List(bleManager.peripherals){ peripherals in
                    
                    Button(action: {
                        bleManager.connectPeripheral(item: peripherals)
                        isConnected = true
                        self.bleManager.stopScanning()
                    }) {
                        HStack{
                        Text(peripherals.name)
                            Spacer()
                        Text(String(peripherals.rssi))
                            }
                    }
                } .frame(height:300)
            
                Spacer()
                
                Button(action:{
                    self.bleManager.startScanning()                },label:{
                    Text("Start Scanning")
                        .bold()
                        .font(.system(size: 30))
                })
                    .foregroundColor(Color(red: 0.80, green: 81, blue: 100))

                Spacer()
                Button(action:{
                    /*
                    self.bleManager.sendData(selectedmode: modeSelect)
                     */
                    self.bleManager.stopScanning()                },label:{
                    Text("Stop Scanning")
                        .bold()
                        .font(.system(size: 30))
                })
                    .foregroundColor(Color(red: 81, green: 0.81, blue: 100))

                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

struct Connections_Previews: PreviewProvider {
    static var previews: some View {
        Connections(status: .constant(true),isConnected: .constant(false))
    }
}
