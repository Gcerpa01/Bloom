//
//  BLEManager.swift
//  Bloom
//
//  Created by Gerardo on 11/26/21.
//

import Foundation
import CoreBluetooth

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
    var bloomCommand:CBCharacteristic!
    
    var dataVal : UInt = 1
    
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
        
        /*
         if(peripheralName == "Unknown"){
         let unknownPeripheral = Peripheral(id:peripherals.count, name: peripheralName, rssi: RSSI.intValue)
         print("unknown peripheral: \(unknownPeripheral)")
         peripherals.append(unknownPeripheral)
         
         }
         */
        
        if(peripheralName != "Unknown"){
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
    }
    
    //Check for peripherals services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            self.bloomDevice.discoverServices(nil)
    }
    
    ///display the peripherals services and match to the one we know is Bloom
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let peripheralServices = peripheral.services {
                    print("list of services")
                    for service in peripheralServices {
                            print(service.uuid)
                            print(service.uuid.uuidString)
                
                    if service.uuid == CBUUID(string:"FFE0"){
                        self.bloomDevice.discoverCharacteristics(nil, for: service)
                    }
                
                        }
                }
    }
    
    //Find characteristics of the [eripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let serviceCharacteristics = service.characteristics {
            print("list of characteristics")
            for characteristic in serviceCharacteristics {
                print(characteristic) //find available characteristics
                if characteristic.uuid == CBUUID(string:"41FF"){
                    print("connected")
                    self.bloomCommand = characteristic
                }
            }
        }
    }
    
    //print if peripheral is disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral Disconnected")
        //myCentral.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    
    func sendData(){
        let dataToWrite = NSData(bytes: &dataVal, length: MemoryLayout<UInt8>.size)
        self.bloomDevice.writeValue(dataToWrite as Data, for: bloomCommand,  type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == bloomCommand.uuid {
            if error != nil {
                print("code not sent")
            }
            else {
                print("code sent")
            }
        }
    }
    
}

