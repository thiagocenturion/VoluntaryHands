//
//  LoginCoordinator.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct LoginCoordinator: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State private var loginSuccess = false
    @State private var signUp = false
    
    var body: some View {
        VStack {
            LoginContainerView(onCommitSignUp: { signUp = true }, onCommitForgotPassword:  { () })
                .environmentObject(
                    store.derived(
                        deriveState: \.login,
                        embedAction: AppAction.login)
                )
                .onReceive(Just(store.state.login.loginSuccess)) { success in
                    loginSuccess = success
                }
            
            NavigationLink(destination: RegisterCoordinator(), isActive: $signUp) {
                EmptyView()
            }.hidden()
        }
    }
}

struct LoginCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        LoginCoordinator()
    }
}
