//
//  BLEManager.swift
//  Bloom
//
//  Created by Gerardo on 11/26/21.
//

import Foundation
import CoreBluetooth
import SwiftUI


struct Peripheral: Identifiable{
    let id: Int
    var name: String
    let rssi: Int
}


class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate,CBPeripheralDelegate{
    var myCentral: CBCentralManager!
    //let serviceUUID = CBUUID(string: "41FF")
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var CBperipherals = [CBPeripheral]()
    
    var bloomDevice:CBPeripheral!
    var bloomCommandMode:CBCharacteristic!
    var bloomCustomColors:CBCharacteristic!
    var connected: Bool = false
    
    var dataVal : UInt8 = 255
    
    static let shared = BLEManager()
    
    
    override init(){
        super.init()
        myCentral = CBCentralManager(delegate:self, queue: nil)
        myCentral.delegate = self
    }
    
    
    //CHeck if bluetooth is On or off
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    
    //Find peripherals with registered names
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String{
            peripheralName = name
        }
        else{
            peripheralName = "Unknown"
        }
        
        
        if(peripheralName.contains("Bloom")){
            let newPeripheral = Peripheral(id:peripherals.count, name: peripheralName, rssi: RSSI.intValue)
            print(newPeripheral)
            peripherals.append(newPeripheral)
            CBperipherals.append(peripheral)
            print(peripheral)
        }
        
    }
    
    //Scan
    func startScanning(){
        print("Scanning Devices")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    //Stop Scanning
    func stopScanning(){
        print("Yeeting Devices")
        myCentral.stopScan()
    }
    
    //Connect to the device
    func connectPeripheral(item:Peripheral){
        bloomDevice = CBperipherals[item.id]
        self.bloomDevice.delegate = self
        myCentral.connect(bloomDevice)
        connected = true
    }
    
    //Check for peripherals services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            self.bloomDevice.discoverServices(nil)
    }
    
    ///display the peripherals services and match to the one we know is Bloom
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            //print list of services provided by peripheral
            if let peripheralServices = peripheral.services {
                    print("list of services")
                    for service in peripheralServices {
                            print(service.uuid)
                            print(service.uuid.uuidString)
                    //check for known coded source froma Arduino Project
                    if service.uuid == CBUUID(string:"f56d1221-e24d-4b61-bbb6-cb8929f3a63b"){
                        self.bloomDevice.discoverCharacteristics(nil, for: service)
                    }
                        }
                }
    }
    
    //Find characteristics of the Peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let serviceCharacteristics = service.characteristics {
            print("list of characteristics")
            for characteristic in serviceCharacteristics {
                print(characteristic) //find available characteristics
                if characteristic.uuid == CBUUID(string: "49360c8a-37b2-4fb8-b7f5-9957cb972fbc"){
                    self.bloomCommandMode = characteristic
                }
                else if characteristic.uuid == CBUUID(string: "325d04af-b205-4b96-a656-4ca6547159c8"){
                    self.bloomCustomColors = characteristic
                }
            }
        }
        self.sendAnimation(selectedmode: "CC")
    }
    
    //Attempt to reconnect if disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral bloomDevice: CBPeripheral, error: Error?) {
        central.connect(bloomDevice, options: nil)
    }
    
    
    
    func sendAnimation(selectedmode:String){
        //dataVal = selectedmode
        //convert digit to NSData type for sending over BLE
        //**Sending Data for String**//
        let valueString = (selectedmode as NSString).data(using: String.Encoding.utf8.rawValue)
        bloomDevice.writeValue(valueString!, for: bloomCommandMode, type: CBCharacteristicWriteType.withResponse)
        
    }
    

    func sendCustomColor(hue:Double,sat:Double, brightness:Double){
        //dataVal = selectedmode
        //convert digit to NSData type for sending over BLE
        //**Sending Data for String**//
        
        let s_hue = String(Int(max(0,min(255,(hue/1.0)*255))))
        let s_sat = String(Int(max(0,min(255,(sat/1.6)*255))))
        let s_bright = String(Int(max(0,min(255,(brightness/1.0)*255))))
        let customColor = s_hue + "," + s_sat + "," + s_bright
        let valueString = (customColor as NSString).data(using: String.Encoding.utf8.rawValue)
        bloomDevice.writeValue(valueString!, for: bloomCustomColors, type: CBCharacteristicWriteType.withResponse)
    }
    
}


