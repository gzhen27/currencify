//
//  ContentView.swift
//  Currencify
//
//  Created by G Zhen on 9/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var currencyManager = CurrencyManager()
    
    private let userInterface = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        GeometryReader { geo in
            LazyVStack {
                if userInterface == .phone {
                    HeaderViewForPhone(size: geo.size)
                }
                
                if userInterface == .pad {
                    HeaderViewForPad(size: geo.size)
                }

                Text("Rates Content")
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

struct HeaderViewForPhone: View {
    let size: CGSize
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack {
                Circle()
                    .frame(width: size.width*0.3)
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: size.width * 0.4, height: 50)
                    .padding()
                Spacer()
            }
        }
        .frame(width: size.width, height: size.height*0.3)
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
