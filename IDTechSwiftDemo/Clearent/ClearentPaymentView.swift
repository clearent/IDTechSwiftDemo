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
    
    private var clearentPay:ClearentPay!
    
    init(_ baseUrl: String, _ publicKey: String) {
        contentViewModel = ContentViewModel()
        self.clearentPay = ClearentPay(contentViewModel: contentViewModel, baseUrl:baseUrl, publicKey:publicKey)
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
                Text("Last 5 of Device Serial Number")
                        .fontWeight(.medium)
                
                TextField("Enter last 5 device serial number", text: $contentViewModel.deviceSerialNumber)
                .frame(width: 250.0, height: 50.0, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            }
                   
            HStack{
                if(contentViewModel.bluetoothConnected) {
                    Text("Connected")
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Text("Not Connected")
                }
            }
            
            Spacer()
            
            VStack{
                Text("(Press button on reader)")
                .foregroundColor(pressButtonColor)
                .font(.subheadline)
                
            Button(action:
                {
                    self.contentViewModel.feedbackDisplay = self.contentViewModel.feedbackDisplay + "Processing\n"
                    self.contentViewModel.processing = true
                    self.startTransaction()
                    
            }) {
            
                HStack {
                    Text("Start Pay")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(payButtonColor)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                }
                
            }.disabled(contentViewModel.processing)
            

            Button(action:
                {
                    self.contentViewModel.processing = false;
                    self.cancelPay()
                }) {
                    HStack {
                        Text("Cancel Pay")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(cancelButtonColor)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                    }
                }
            }
            Spacer()
            
            List{
                Text(contentViewModel.feedbackDisplay).lineLimit(100).padding(20)
            }
        }
    }
    
    var cancelButtonColor: Color {
        return .blue
    }
   
    var payButtonColor: Color {
        if(contentViewModel.processing) {
               return .gray
           }
           return .blue
       }
    
    
    var pressButtonColor: Color {
        if(contentViewModel.processing) {
               return .gray
           }
           return .blue
       }
    
        func cancelPay() {
            clearentPay.cancelTransaction()
        }
    
    public func notifyBluetoothDevice(friendlyName:String, uuid:UUID) {
        self.clearentPay.addBluetoothDevice(friendlyName: friendlyName, uuid: uuid)
    }

    func startTransaction() {
        clearentPay.startTransaction()
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
    @Published var deviceSerialNumber = "54997"
    @Published var bluetoothConnected = false
    @Published var feedbackDisplay = ""
}

