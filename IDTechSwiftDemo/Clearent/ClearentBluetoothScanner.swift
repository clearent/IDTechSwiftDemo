//
//  ClearentBluetoothScanner.swift
//  IDTechSwiftDemo
//
//  Created by David Higginbotham on 10/23/19.
//  Copyright © 2019 David Higginbotham. All rights reserved.
//

import Foundation
//
//  ScanViewController.swift
//  MobileMiddlewareUIPlayground
//
//  Created by David Yoo on 7/11/19.
//  Copyright © 2019 Clearent. All rights reserved.
//

import UIKit
import CoreBluetooth

class ClearentBluetoothScanner: NSObject, CBCentralManagerDelegate {
    var manager: CBCentralManager!
    var peripherals: [CBPeripheral] = []
    var peripheralLocalNames: [String] = []
    var lookForFriendlyName: String
    var  clearentPayment:ClearentPayment
   
    init(lookForFriendlyName:String,  clearentPayment:ClearentPayment) {
        self.lookForFriendlyName = lookForFriendlyName
        self.clearentPayment = clearentPayment
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func scanForDevices() {
        manager.scanForPeripherals(withServices: [CBUUID(string: "1820")], options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.stopScanForDevices()
        }
    }
    
    func stopScanForDevices() {
        manager.stopScan()
    }
        
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                if localName.contains(lookForFriendlyName) {
                    peripherals.append(peripheral)
                    print(localName)
                    print(peripheral)
                    peripheralLocalNames.append(localName)
                    clearentPayment.addBluetoothDevice(friendlyName: localName, uuid: peripheral.identifier)
                }
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
}

