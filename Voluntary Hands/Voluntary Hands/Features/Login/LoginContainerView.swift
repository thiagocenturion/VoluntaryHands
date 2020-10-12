//
//  LoginContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct LoginContainerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var store: Store<LoginState, LoginAction>

    @State private var formItems = [
        FormItem(
            title: "CPF / CNPJ",
            maskInText: { $0.onlyNumbers.count <= 11 ? "999.999.999-99" : "99.999.999/9999-99" },
            keyboardType: .numberPad,
            textContentType: .username,
            isSecure: false,
            validateInText: { newValue in
                
                if newValue.isEmpty {
                    return (errorMessage: nil, isValid: false)
                } else if newValue.onlyNumbers.count <= 11 {
                    let errorMessage = newValue.isCPF ? nil : "O CPF digitado é inválido."
                    return (errorMessage: errorMessage, isValid: errorMessage == nil)
                } else {
                    let errorMessage = newValue.isCNPJ ? nil : "O CNPJ digitado é inválido."
                    return (errorMessage: errorMessage, isValid: errorMessage == nil)
                }
            }
        ),
        FormItem(title: "SENHA", keyboardType: .webSearch, textContentType: .password, isSecure: true, validateInText: { (errorMessage: nil, isValid: !$0.isEmpty) }),
    ]
    
    @State private var usernameErrorMessage: String?
    @State private var signInEnabled = false
    
    private var alertShown: Binding<AlertError?> {
        store.binding(for: \.alert) { _ in .alert(error: nil) }
    }
    
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void
    
    // MARK: - View
    var body: some View {

        LoginView(
            formItems: $formItems,
            signInEnabled: $signInEnabled,
            loading: store.state.loading,
            onCommitSignIn: requestSignIn,
            onCommitSignUp: onCommitSignUp,
            onCommitForgotPassword: onCommitForgotPassword
        )
        .onAppear {
            self.formItems.first { $0.title == "SENHA" }?.onCommit = signInEnabled ? requestSignIn : { }
        }
        .onReceive(Just(formItems)) { formItems in
            signInEnabled = formItems.map { $0.validateInText($0.text).isValid }.reduce(&&)
        }
        .alert(item: alertShown, content: { alertError -> Alert in
            Alert(
                title: Text(alertError.title),
                message: Text(alertError.message),
                dismissButton: nil)
        })
    }
}

// MARK: - Requets

extension LoginContainerView {
    
    private func requestSignIn() {
        store.send(.signIn(username: formItems[0].text, password: formItems[1].text))
    }
}

// MARK: - Previews
struct LoginContainerView_Previews: PreviewProvider {
    static var previews: some View {
        LoginContainerView(
            onCommitSignUp: { () },
            onCommitForgotPassword: { () }
        )
    }
}
