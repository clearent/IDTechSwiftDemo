//
//  ContentView.swift
//  IDTechSwiftDemo
//
//  Created by David Higginbotham on 10/23/19.
//  Copyright © 2019 David Higginbotham. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var processing = false
    @State private var amount: String = "1.00"
    
    @State private var feedback: String = ""
    
    var body: some View {
        VStack {
            Text("IDTech Swift Demo")
                .fontWeight(.semibold)
    
            TextField("Enter amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action:
                {
                    self.feedback = self.feedback + "Processing\n"
                    self.processing = true
            }) {
                HStack {
                    Text("Pay")
                }
            }.disabled(self.processing)
            
            Spacer()
            
            TextField("Results", text: $feedback)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(Color.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
