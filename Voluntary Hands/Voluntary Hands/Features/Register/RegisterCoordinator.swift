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
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack {
            RegisterDataContainerView(activeSheet: $activeSheet)
                .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
                .environmentObject(
                    store.derived(
                        deriveState: \.register,
                        embedAction: AppAction.register)
                )
                .onReceive(Just(store.state.register.registerSuccess)) { success in
                    registerSuccess = success
                }
                .onAppear { registerSuccess = false }
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .useTerms: Safari(url: URL(string: "https://sharp-fermi-0463a9.netlify.app/terms.html")!)
                    case .privacyPolicy: Safari(url: URL(string: "https://sharp-fermi-0463a9.netlify.app")!)
                    }
                }
            
            NavigationLink(
                destination: Text("Causas de Apoio").navigationBarTitle("CAUSAS"),
                isActive: $registerSuccess) {
                EmptyView()
            }.hidden()
        }
    }
}

extension RegisterCoordinator {
    
    enum ActiveSheet: Identifiable {
        case useTerms
        case privacyPolicy
        
        var id: Int { hashValue }
    }
}

struct RegisterCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCoordinator()
    }
}
