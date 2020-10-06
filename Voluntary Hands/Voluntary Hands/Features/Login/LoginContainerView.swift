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
    @State private var username = ""
    @State private var password = ""
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
            username: $username,
            password: $password,
            usernameErrorMessage: $usernameErrorMessage,
            signInEnabled: $signInEnabled,
            loading: store.state.loading,
            onCommitSignIn: requestSignIn,
            onCommitSignUp: onCommitSignUp,
            onCommitForgotPassword: onCommitForgotPassword
        )
        .onReceive(Just(username)) { newValue in
            validateUsername(newValue)
        }
        .alert(item: alertShown, content: { alertError -> Alert in
            Alert(
                title: Text(alertError.title),
                message: Text(alertError.message),
                dismissButton: nil)
        })
    }
    
    func validateUsername(_ username: String) {
        if username.isEmpty {
            usernameErrorMessage = nil
            signInEnabled = false
        } else if username.onlyNumbers.count <= 11 {
            let errorMessage = username.isCPF ? nil : "O CPF digitado é inválido."
            
            usernameErrorMessage = errorMessage
            signInEnabled = errorMessage == nil
        } else {
            let errorMessage = username.isCNPJ ? nil : "O CNPJ digitado é inválido."
            
            usernameErrorMessage = errorMessage
            signInEnabled = errorMessage == nil
        }
    }
}

// MARK: - Requets

extension LoginContainerView {
    
    private func requestSignIn() {
        store.send(.signIn(username: username, password: password))
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
