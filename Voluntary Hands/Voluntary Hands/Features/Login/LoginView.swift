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
    
    @Binding var usernameErrorMessage: String?
    @Binding var signInEnabled: Bool
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    var content: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 150, idealHeight: 200, maxHeight: 200, alignment: .center)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                FloatingTextField(title: "CPF / CNPJ", text: $username, error: $usernameErrorMessage, isSecure: false, onCommit: { })
                    .mask(username.onlyNumbers.count <= 11 ? "999.999.999-99" : "99.999.999/9999-99")
                    .keyboardType(.numberPad)
                FloatingTextField(title: "SENHA", text: $password, error: .constant(nil), isSecure: true, onCommit: signInEnabled ? onCommitSignIn : { })
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
                .padding(.bottom, 10)
                .buttonStyle(PrimaryBackgroundStyle(isDisabled: !signInEnabled))
                .disabled(!signInEnabled)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(
                username: .constant(""),
                password: .constant(""),
                usernameErrorMessage: .constant(nil),
                signInEnabled: .constant(true),
                loading: false,
                onCommitSignIn: { },
                onCommitSignUp:  { },
                onCommitForgotPassword: { }
            )
            .previewDevice("iPhone SE (2nd generation)")
            LoginView(
                username: .constant(""),
                password: .constant(""),
                usernameErrorMessage: .constant("CPF inválido."),
                signInEnabled: .constant(false),
                loading: false,
                onCommitSignIn: { },
                onCommitSignUp:  { },
                onCommitForgotPassword: { }
            )
            .previewDevice("iPhone 11")
        }
    }
}
