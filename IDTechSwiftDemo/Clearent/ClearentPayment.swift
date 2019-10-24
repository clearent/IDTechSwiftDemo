//
//  ClearentPayment.swift
//  IDTechSwiftDemo
//
//  Created by David Higginbotham on 10/23/19.
//  Copyright © 2019 David Higginbotham. All rights reserved.
//

import Foundation
import ClearentIdtechIOSFramework

class ClearentPayment: NSObject, ClearentManualEntryDelegate, Clearent_Public_IDTech_VP3300_Delegate  {
   
    var contentViewModel: ContentViewModel
    let clearentVP3300 = Clearent_VP3300()
    
    init(contentViewModel:ContentViewModel, baseUrl:String, publicKey:String) {
        self.contentViewModel = contentViewModel
        super.init()
        self.initializeClearentVP3300(baseUrl: baseUrl, publicKey: publicKey)
    }

    func initializeClearentVP3300( baseUrl:String, publicKey:String) {
        clearentVP3300.`init`(self, clearentBaseUrl: baseUrl, publicKey: publicKey)
        clearentVP3300.setAutoConfiguration(false)
        print("clearentVP3300 has been initialized")
    }
    
    public func addBluetoothDevice(friendlyName:String, uuid:UUID) {
        clearentVP3300.device_setBLEFriendlyName(friendlyName)
        clearentVP3300.device_enableBLEDeviceSearch(uuid)
    }
    
    func handleManualEntryError(_ message: String!) {
        print("handleManualEntryError")
        contentViewModel.feedback.append(contentsOf: message)
    }
    
    func isReady() {
        print("isReady")
        contentViewModel.feedback.append(contentsOf: "Reader is Ready")
        contentViewModel.bluetoothConnected = true
    }
    
    func successfulTransactionToken(_ jsonString: String!) {
        print("successfulTransactionToken")
        contentViewModel.feedback.append(contentsOf: jsonString)
    }
    
    func plugStatusChange(_ deviceInserted: Bool) {
        //TODO
    }
    
    func deviceConnected() {
        print("DEVICE IS CONNECTED")
    }
    
    func deviceDisconnected() {
        print("DEVICE IS DISCONNECTED")
        contentViewModel.feedback.append(contentsOf: "Reader is disconnected")
        contentViewModel.bluetoothConnected = false
    }
    
    func deviceMessage(_ message: String!) {
        print("DEVICE MESSAGE: \(message!)")
        contentViewModel.feedback.append(contentsOf: message)
    }
    
    func data(inOutMonitor data: Data?, incoming isIncoming: Bool) {
        print("DATA: \(data!.description)")
    }
    
    func lcdDisplay(_ mode: Int32, lines: [Any]?) {
        if nil != lines {
            print("LINES: \(lines!)")
            for s: Any in lines! {
                let line = s as! String
                print("LCD: \(line)")
                switch line {
                case "SWIPE OR INSERT", "INSERT/SWIPE":
                    contentViewModel.feedback.append(contentsOf: line)
                case "PROCESSING…":
                   contentViewModel.feedback.append(contentsOf: line)
                case "GO ONLINE", "AUTHORIZING…":
                   contentViewModel.feedback.append(contentsOf: line)
                case "USE CHIP READER":
                    contentViewModel.feedback.append(contentsOf: line)
                case "USE MAGSTRIPE":
                    contentViewModel.feedback.append(contentsOf: line)
                case "TIME OUT", "TIMEOUT":
                    contentViewModel.feedback.append(contentsOf: line)
                case "TERMINATED":
                    contentViewModel.feedback.append(contentsOf: line)
                default:
                    contentViewModel.feedback.append(contentsOf: "Unhandled LCD message " + line)
                    return
                }
            }
        }
    }
    
    func startTransaction() {
        clearentVP3300.emv_disableAutoAuthenticateTransaction(false)
        let amount = Double(contentViewModel.amount)!
        let rt:RETURN_CODE = clearentVP3300.emv_startTransaction(amount, amtOther: 0, type: 0, timeout: 60, tags: nil, forceOnline: false, fallback: true)
        //            let rt:RETURN_CODE = clearentVP3300.device_startTransaction(0, amtOther: 0, type: 0, timeout: 60, tags: nil, forceOnline: false, fallback: true)
        if RETURN_CODE_DO_SUCCESS == rt {
            contentViewModel.feedback.append(contentsOf: "Transaction Successfully Started")
        } else {
            print("Start Transaction info \(rt)")
            contentViewModel.feedback.append(contentsOf: "Transaction Failed to Start")
        }
    }
    
}
