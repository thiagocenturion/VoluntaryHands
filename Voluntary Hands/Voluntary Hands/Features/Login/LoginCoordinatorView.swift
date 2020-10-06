//
//  LoginCoordinatorView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct LoginCoordinatorView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State private var loginSuccess = false
    
    var body: some View {
        LoginContainerView(onCommitSignUp: { () }, onCommitForgotPassword:  { () })
            .environmentObject(
                store.derived(
                    deriveState: \.login,
                    embedAction: AppAction.login)
            )
            .onReceive(Just(store.state.login.loginSuccess)) { success in
                loginSuccess = success
            }
//        NavigationLink(<#T##title: StringProtocol##StringProtocol#>, destination: <#T##_#>, tag: <#T##Hashable#>, selection: <#T##Binding<Hashable?>#>)
//        NavigationLink(destination: Text("Feed destination"), isActive: $loginSuccess) {
//
//        }
    }
}

struct LoginCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        LoginCoordinatorView()
    }
}
