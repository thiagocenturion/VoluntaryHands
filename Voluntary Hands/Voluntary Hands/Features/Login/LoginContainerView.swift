//
//  LoginContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct LoginContainerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var store: Store<LoginState, LoginAction>
    @State private var username = ""
    @State private var password = ""
    
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void
    
    // MARK: - View
    var body: some View {
        LoginView(
            username: $username,
            password: $password,
            loading: store.state.loading,
            onCommitSignIn: requestSignIn,
            onCommitSignUp: onCommitSignUp,
            onCommitForgotPassword: onCommitForgotPassword
        )
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
