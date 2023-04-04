//
//  ContentView.swift
//  Currencify
//
//  Created by G Zhen on 9/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var currencyManager = CurrencyManager()
    @State private var currencyCode = "USD"
    
    private let userInterface = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if userInterface == .phone {
                    HeaderViewForPhone(currencyManager: currencyManager, currencyCode: $currencyCode, size: geo.size)
                }
                
                if userInterface == .pad {
                    HeaderViewForPad(size: geo.size)
                }

                ScrollView {
                    LazyVStack {
//                        let rates = currencyManager.latestResponse?.rates ?? [String: Double]()
                        let rates = ["STD": 23049.83259847, "XRP": 2.74546112, "MAD": 10.42408349, "AMD": 383.84278385, "AFN": 88.03109682, "GEL": 2.59249994, "SAR": 3.75, "SCR": 13.96844021, "MOP": 8.0833981, "UGX": 3712.78836244, "XLM": 12.60378986, "BND": 1.34974702, "GHS": 12.10323247, "GMD": 61.24783098, "DKK": 6.99632692, "TVD": 1.51894417, "CRC": 549.74690869, "FRF": 6.16244791, "THB": 34.82221113, "BWP": 13.3722144, "MDL": 18.71035134]
                        let codes = Array(rates.keys).sorted()
                        ForEach(codes, id: \.self) { code in
                            VStack {
                                HStack {
                                    CodeIcon(code: code)
                                    Text(CurrencyHelper.getCurrencyName(code: code))
                                    Spacer()
                                    Text("\(CurrencyHelper.formatRate(code: code, rate: rates[code]))")
                                }
                                Divider()
                            }
                            .padding(10)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .task {
//            currencyManager.getLatest(for: "USD")
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

struct CodeIcon: View {
    var code: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 38)
                Text(code)
                    .foregroundColor(.white)
                    .font(.footnote)
            }
        }
    }
}

struct HeaderViewForPhone: View {
    @ObservedObject var currencyManager: CurrencyManager
    @Binding var currencyCode: String
    let size: CGSize
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 80)
                Text(currencyCode)
                    .foregroundColor(.white)
                    .font(.title)
            }
            .onTapGesture {
                print("Circle was tapped")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
}

struct HeaderViewForPad: View {
    let size: CGSize
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: size.width*0.25)
                    .padding(.leading, size.width*0.1)
                Spacer()
            }
        }
        .frame(width: size.width, height: size.height*0.3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
