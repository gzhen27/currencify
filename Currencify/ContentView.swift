//
//  ContentView.swift
//  Currencify
//
//  Created by G Zhen on 9/23/22.
//

import SwiftUI

struct ContentView: View {
    @State var isPresentSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            Button("Test Endpoints") {
                isPresentSheet.toggle()
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isPresentSheet) {
            TestEndpointView()
        }
    }
}

struct TestEndpointView: View {
    @StateObject var currencyManager = CurrencyManager()
    
    var body: some View {
        VStack {
            if let response = currencyManager.convertResponse {
                Text("\(response.from) \(response.amount)")
                Text("To: \(response.to)")
                Text("\(response.to) \(response.value)")
            }
            
            if let response = currencyManager.latestResponse {
                Text("Code: \(response.base)")
                Text("Date: \(response.date)")
                Text("Rate to CNY: \(response.rates["CNY"] ?? 0.0)")
            }
            Button("Convert CNY") {
                currencyManager.convert(to: "CNY", from: "USD", amount: "100")
            }
            .padding()
            Button("Convert JPY") {
                currencyManager.convert(to: "JPY", from: "USD", amount: "100")
            }
            .padding()
            Button("Get latest for USD") {
                currencyManager.getLatest(for: "USD")
            }
            .padding()
            Button("Get currencies") {
                currencyManager.getCurrencies(for: "fiat")
            }
        }
        .alert(isPresented: $currencyManager.isPresentError) {
            Alert(
                title: Text("Error Occurs"),
                message: Text(currencyManager.errorMessage ?? "Please try again later."),
                dismissButton: Alert.Button.default(Text("OK")) {
                    currencyManager.clearErrorStatus()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestEndpointView()
    }
}
