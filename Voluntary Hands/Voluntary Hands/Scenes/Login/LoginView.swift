//
//  LoginView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - View
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 215)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                TextFieldFloating("E-MAIL", text: self.$email)
                TextFieldFloating("SENHA", text: self.$password)
                Button("ESQUECI MINHA SENHA") {}
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: { }) {
                    HStack {
                        Spacer()
                        Text("CADASTRE-SE")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                }
                .buttonStyle(SecondaryBackgroundStyle(color: ColorStyle.red))
                
                Button(action: { }) {
                    HStack {
                        Spacer()
                        Text("LOGIN")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                }
                .buttonStyle(PrimaryBackgroundStyle())
            }
            
        }
        .padding(27.5)
        .background(ColorStyle.grayDark)
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
