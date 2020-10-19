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
    
    private var currentImageData: Binding<Data?> {
        Binding<Data?>(
            get: { store.state.register.currentImage },
            set: { store.send(.register(action: .currentImage(data: $0))) }
        )
    }
    
    private var alertShown: Binding<AlertError?> {
        Binding<AlertError?>(
            get: { store.state.register.alert },
            set: { _ in store.send(.register(action: .alert(error: nil))) }
        )
    }
    
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
                    case .imagePicker: ImagePicker(imageData: currentImageData)
                    }
                }
                .alert(item: alertShown, content: { alertError -> Alert in
                    Alert(
                        title: Text(alertError.title),
                        message: Text(alertError.message),
                        dismissButton: nil)
                })
            
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
        case imagePicker
        
        var id: Int { hashValue }
    }
}

struct RegisterCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCoordinator()
    }
}
