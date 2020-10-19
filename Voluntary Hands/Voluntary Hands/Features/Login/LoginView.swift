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
    @State private var signInEnabled: Bool = false
    @StateObject private var username = StringLimit(text: "", limit: 18)
    @State private var usernameError: String?
    @State private var password = ""

    var loading: Bool
    let onCommitSignIn: (_ username: String, _ password: String) -> Void
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void
    
    // MARK: - View
    
    var body: some View {
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onReceive(Just([username.text.validation(.cpfAndCnpj), password.validation(.empty)])) { validates in
                signInEnabled = validates.map { $0.isValid }.reduce(&&)
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
                
                FloatingTextField(
                    title: "CPF / CNPJ",
                    text: $username.text,
                    error: $usernameError,
                    isSecure: false,
                    mask: { $0.onlyNumbers.count <= 11 ? "999.999.999-99" : "99.999.999/9999-99" },
                    validate: { $0.validation(.cpfAndCnpj) }
                )
                .keyboardType(.numberPad)
                .textContentType(.username)
                
                FloatingTextField(
                    title: "SENHA",
                    text: $password,
                    isSecure: true,
                    validate: { $0.validation(.empty) },
                    onCommit: {
                        if signInEnabled {
                            onCommitSignIn(username.text, password)
                        }
                    }
                )
                .keyboardType(.webSearch)
                .textContentType(.password)
                
                Button(action: onCommitForgotPassword) {
                    Text("ESQUECI MINHA SENHA")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                
                FullWidthButton(titleKey: "CADASTRE-SE", action: onCommitSignUp)
                    .buttonStyle(.secondary(color: Color.Style.red))
                
                FullWidthButton(titleKey: "LOGIN", action: { onCommitSignIn(username.text, password) })
                    .buttonStyle(.primary(isDisabled: !signInEnabled))
                    .disabled(!signInEnabled)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(loading: false, onCommitSignIn: { _, _ in }, onCommitSignUp: { }, onCommitForgotPassword: { })
            .previewDevice("iPhone SE (2nd generation)")
            LoginView(loading: false, onCommitSignIn: { _, _ in }, onCommitSignUp: { }, onCommitForgotPassword: { })
            .previewDevice("iPhone 11")
        }
    }
}
