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

    var body: some View {
        if showConnections{
            Connections(status:$showConnections)
                .environmentObject(ble_Manager)
        }
        else if showAudio{
            Audio(status: $showAudio)
            
        }
        else if showAnimation{
            Animations(status:$showAnimation)
        }
        else{
            MainView(value: 1.0,showConnections: $showConnections,showAudio: $showAudio,showAnimation: $showAnimation)
        
        }
   
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
