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
            LazyVStack {
                if userInterface == .phone {
                    HeaderViewForPhone(currencyManager: currencyManager, currencyCode: $currencyCode, size: geo.size)
                }
                
                if userInterface == .pad {
                    HeaderViewForPad(size: geo.size)
                }

                Text("Rates Content")
                Text("\(currencyManager.latestResponse?.base ?? "")")
            }
        }
//        .task {
//            currencyManager.getLatest(for: "USD")
//        }
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

struct HeaderViewForPhone: View {
    @ObservedObject var currencyManager: CurrencyManager
    @Binding var currencyCode: String
    let size: CGSize
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 100)
                    Text(currencyCode)
                        .foregroundColor(.white)
                        .font(.title)
                }
                Spacer()
            }
        }
    }
}

struct HeaderViewForPad: View {
    let size: CGSize
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            VStack {
                HStack {
                    Circle()
                        .frame(width: size.width*0.25)
                        .padding(.leading, size.width*0.1)
                    Spacer()
                }
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
