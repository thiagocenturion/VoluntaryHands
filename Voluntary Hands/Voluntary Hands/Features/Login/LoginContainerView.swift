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
    
    private var alertShown: Binding<AlertError?> {
        store.binding(for: \.alert) { _ in .alert(error: nil) }
    }
    
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void
    
    // MARK: - View
    var body: some View {
        LoginView(
            loading: store.state.loading,
            onCommitSignIn: { username, password in requestSignIn(username, password) },
            onCommitSignUp: onCommitSignUp,
            onCommitForgotPassword: onCommitForgotPassword
        )
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
    
    private func requestSignIn(_ username: String, _ password: String) {
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
