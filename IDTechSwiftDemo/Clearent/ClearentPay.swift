//
//  ClearentPayment.swift
//  IDTechSwiftDemo
//
//  Created by David Higginbotham on 10/23/19.
//  Copyright © 2019 David Higginbotham. All rights reserved.
//

import Foundation
import ClearentIdtechIOSFramework

class ClearentPay: NSObject, ClearentManualEntryDelegate, Clearent_Public_IDTech_VP3300_Delegate  {
    
    var contentViewModel: ContentViewModel
    let clearentVP3300 = Clearent_VP3300()
    
    init(contentViewModel:ContentViewModel, baseUrl:String, publicKey:String) {
        self.contentViewModel = contentViewModel
        super.init()
        self.initializeClearentVP3300(baseUrl: baseUrl, publicKey: publicKey)
    }

    func initializeClearentVP3300( baseUrl:String, publicKey:String) {
        
        let clearentVP3300Config = ClearentVP3300Config.init(contactlessNoConfiguration: baseUrl, publicKey: publicKey);
            
        type(of: clearentVP3300).init(connectionHandling: self, clearentVP3300Configuration: clearentVP3300Config)
        
        clearentVP3300.setAutoConfiguration(false)
        print("clearentVP3300 has been initialized")
    }
    
    public func addBluetoothDevice(friendlyName:String, uuid:UUID) {
        clearentVP3300.device_setBLEFriendlyName(friendlyName)
        clearentVP3300.device_enableBLEDeviceSearch(uuid)
    }
    
    func handleManualEntryError(_ message: String!) {
        print("handleManualEntryError")
        contentViewModel.feedbackDisplay.append(contentsOf: message)
    }
    
    func successTransactionToken(_ clearentTransactionToken: ClearentTransactionToken!) {
        print("successfulTransactionToken")
        contentViewModel.feedbackDisplay.append(contentsOf: "successful tokenization!")
        contentViewModel.feedbackDisplay.append(contentsOf: clearentTransactionToken.jwt)
        contentViewModel.processing = false;
    }
      
    func bluetoothDevices(_ bluetoothDevices: [ClearentBluetoothDevice]!) {
        print("bluetooth devices")
    }
    
    func deviceConnected() {
        contentViewModel.bluetoothConnected = true
    }
    
    func deviceDisconnected() {
        contentViewModel.bluetoothConnected = false
    }
    
    func feedback(_ clearentFeedback: ClearentFeedback!) {
        print("DEVICE MESSAGE: \(clearentFeedback.message!)")
        contentViewModel.feedbackDisplay.append(contentsOf: clearentFeedback.message + "\n")
    }

    func startTransaction() {
        DispatchQueue.global(qos: .background).async {  [weak self] in
            
            let clearentConnection = ClearentConnection.init(bluetoothWithLast5: self!.contentViewModel.deviceSerialNumber)
            
            let amount = Double(self!.contentViewModel.amount)!
            
            let clearentPaymentRequest = ClearentPayment.init(sale: ());
            clearentPaymentRequest?.amount = amount;
            
            let clearentResponse = self!.clearentVP3300.startTransaction(clearentPaymentRequest!, clearentConnection: clearentConnection)
            if 0 != clearentResponse?.idtechReturnCode {
                self?.contentViewModel.feedbackDisplay.append(contentsOf: "Transaction Failed to Start")
            }
        }
    }
    
    func cancelTransaction() {
        DispatchQueue.global(qos: .background).async {  [weak self] in
            _ = self!.clearentVP3300.device_cancelTransaction()
        }
    }
}
