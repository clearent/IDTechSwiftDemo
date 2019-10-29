//
//  ClearentPaymentView.swift
//  IDTechSwiftDemo
//
//  Created by David Higginbotham on 10/23/19.
//  Copyright © 2019 David Higginbotham. All rights reserved.
//

import SwiftUI

struct ClearentPaymentView: View {
    
    @ObservedObject var contentViewModel: ContentViewModel
    
    private var clearentPayment:ClearentPayment!
    private var clearentBluetoothScanner:ClearentBluetoothScanner!
    
    init(_ baseUrl: String, _ publicKey: String) {
        contentViewModel = ContentViewModel()
        self.clearentPayment = ClearentPayment(contentViewModel: contentViewModel, baseUrl:baseUrl, publicKey:publicKey)
        self.clearentBluetoothScanner = ClearentBluetoothScanner(lookForFriendlyName: contentViewModel.deviceSerialNumber, clearentPayment:self.clearentPayment)
    }
    
    var body: some View {
       
        VStack {
            Text("IDTech Swift Demo")
                .fontWeight(.semibold)
        
            HStack{
                Text("Amount")
                    .fontWeight(.medium)
        
                TextField("Enter amount", text: $contentViewModel.amount)
                    .frame(width: 100.0, height: 50.0, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            
            HStack{
                Text("Device Serial Number")
                        .fontWeight(.medium)
                
                TextField("Enter device serial number", text: $contentViewModel.deviceSerialNumber)
                .frame(width: 250.0, height: 50.0, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            }
            
            HStack{
                Button(action:
                    {
                        self.startBluetoothScan()
                        
                }) {
                    VStack{
                        HStack {
                            Text("Connect")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(connectButtonColor)
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .padding(10)
                        }
                        Text("(Press button on reader)")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                }.disabled(contentViewModel.processing || contentViewModel.bluetoothConnected)
                
            }
            
            Spacer()
            
            HStack{
                if(contentViewModel.bluetoothConnected) {
                    Text("Connected")
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Text("Not Connected")
                }
            }
            
            Spacer()
            
            Button(action:
                {
                    self.contentViewModel.feedback = self.contentViewModel.feedback + "Processing\n"
                    self.contentViewModel.processing = true
                    self.startTransaction()
                    
            }) {
                HStack {
                    Text("Pay")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(payButtonColor)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(10)
                }
            }.disabled(contentViewModel.processing || !contentViewModel.bluetoothConnected)
            
            Spacer()
            List{
                Text(contentViewModel.feedback).lineLimit(100).padding(20)
//                TextField("Results", text: $contentViewModel.feedback)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .background(Color.gray)
            }
        }
    }
    
    var connectButtonColor: Color {
        if(contentViewModel.processing || contentViewModel.bluetoothConnected) {
            return .gray
        }
        return .blue
    }
   
    var payButtonColor: Color {
           if(contentViewModel.processing || !contentViewModel.bluetoothConnected) {
               return .gray
           }
           return .blue
       }
    
    func startBluetoothScan() {
        self.clearentBluetoothScanner.scanForDevices();
    }
    
    public func notifyBluetoothDevice(friendlyName:String, uuid:UUID) {
        self.clearentPayment.addBluetoothDevice(friendlyName: friendlyName, uuid: uuid)
    }

    func startTransaction() {
        clearentPayment.startTransaction()
    }
}

struct ClearentPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ClearentPaymentView("baseurl","publickey")
    }
}


final class ContentViewModel: ObservableObject {
    @Published var processing = false
    @Published var amount = "1.00"
    @Published var deviceSerialNumber = "IDTECH-VP3300-92225"
    @Published var bluetoothConnected = false
    @Published var feedback = ""
}

