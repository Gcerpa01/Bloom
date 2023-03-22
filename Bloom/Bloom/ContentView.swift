//
//  ContentView.swift
//  Bloom
//
//  Created by Gerardo on 10/10/21.
//

import SwiftUI
import CoreBluetooth



struct ContentView: View {
    @StateObject var ble_Manager = BLEManager()
    
    @State private var showConnections:Bool = false
    @State private var showAudio:Bool = false
    @State private var showAnimation:Bool = false
    @State private var AVImode:String = "OFF"
    @State private var connectionStatus = false

    var body: some View {
        if showConnections{
            Connections(status:$showConnections,isConnected: $connectionStatus)
                .environmentObject(ble_Manager)
        }
        else if showAudio && connectionStatus{
            Audio(status: $showAudio,chosenMode: $AVImode)
                .environmentObject(ble_Manager)
            
        }
        else if showAnimation && connectionStatus{
            Animations(status:$showAnimation, chosenMode: $AVImode)
                .environmentObject(ble_Manager)
        }
        else{
            MainView(value: 50.0, selected_position: CGPoint(x:125,y:125),showConnections: $showConnections,showAudio: $showAudio,showAnimation: $showAnimation, chosenMode:$AVImode,isConnected: $connectionStatus)
                .environmentObject(ble_Manager)
        
        }
   
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
