//
//  LoginView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    // MARK: - Properties
    @Binding var username: String
    @Binding var password: String
    
    var loading: Bool
    
    let onCommitSignIn: () -> Void
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void

    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                if loading {
                    ActivityView()
                    content.opacity(0.3)
                } else {
                    content
                }
            }
            .padding(27.5)
            .background(Color.Style.grayDark)
            .ignoresSafeArea(.container, edges: .vertical)
        }
        .preferredColorScheme(.dark)
    }
    
    var content: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 215)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                FloatingTextField(title: "CPF / CNPJ", text: $username, isSecure: false, onCommit: { })
                    .keyboardType(.numberPad)
                    .onReceive(Just(username)) { newValue in
                        username = newValue.onlyNumbers.count <= 11 ?
                            newValue.string(withMask: "999.999.999-99") :
                            newValue.string(withMask: "99.999.999/9999-99")
                    }
                FloatingTextField(title: "SENHA", text: $password, isSecure: true, onCommit: onCommitSignIn)
                    .keyboardType(.webSearch)
                Button(action: onCommitForgotPassword) {
                    Text("ESQUECI MINHA SENHA")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                
                Button(action: onCommitSignUp) {
                    HStack {
                        Spacer()
                        Text("CADASTRE-SE")
                        Spacer()
                    }
                }
                .buttonStyle(SecondaryBackgroundStyle(color: Color.Style.red))
                
                Button(action: onCommitSignIn) {
                    HStack {
                        Spacer()
                        Text("LOGIN")
                        Spacer()
                    }
                }
                .buttonStyle(PrimaryBackgroundStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            username: .constant(""),
            password: .constant(""),
            loading: false,
            onCommitSignIn: { },
            onCommitSignUp:  { },
            onCommitForgotPassword: { }
        )
    }
}
