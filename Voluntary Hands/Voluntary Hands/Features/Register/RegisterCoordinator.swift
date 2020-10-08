//
//  RegisterCoordinator.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct RegisterCoordinator: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State private var registerSuccess = false
    
    var body: some View {
        VStack {
            RegisterDataContainerView()
                .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
                .environmentObject(
                    store.derived(
                        deriveState: \.register,
                        embedAction: AppAction.register)
                )
                .onReceive(Just(store.state.register.registerSuccess)) { success in
                    registerSuccess = success
                }
            
            NavigationLink(
                destination: Text("Causas de Apoio").navigationBarTitle("CAUSAS"),
                isActive: $registerSuccess) {
                EmptyView()
            }.hidden()
        }
    }
}

struct RegisterCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCoordinator()
    }
}
