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
    @State private var socialCausesSuccess = false
    
    @State private var activeSheet: ActiveSheet?
    
    private var currentImageData: Binding<Data?> {
        Binding<Data?>(
            get: { store.state.register.currentImage },
            set: { store.send(.register(action: .currentImage(data: $0))) }
        )
    }
    
    private var registerAlertShown: Binding<AlertError?> {
        Binding<AlertError?>(
            get: { store.state.register.alert },
            set: { _ in store.send(.register(action: .alert(error: nil))) }
        )
    }
    
    private var socialCausesAlertShown: Binding<AlertError?> {
        Binding<AlertError?>(
            get: { store.state.socialCauses.alert },
            set: { _ in store.send(.socialCauses(action: .alert(error: nil))) }
        )
    }
    
    var body: some View {
        VStack {
            registerDataView
            NavigationLink(destination: socialCausesView, isActive: $registerSuccess) { EmptyView() }.hidden()
        }
    }
    
    var registerDataView: some View {
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
            .alert(item: registerAlertShown, content: { alertError -> Alert in
                Alert(
                    title: Text(alertError.title),
                    message: Text(alertError.message),
                    dismissButton: nil)
            })
    }
    
    var socialCausesView: some View {
        SocialCausesContainerView()
            .navigationBarTitle("CAUSAS", displayMode: .inline)
            .environmentObject(store.derived(deriveState: \.socialCauses, embedAction: AppAction.socialCauses))
            .onReceive(Just(store.state.socialCauses.savingSuccess)) { success in
                socialCausesSuccess = success
            }
            .onAppear { socialCausesSuccess = false }
            .alert(item: socialCausesAlertShown, content: { alertError -> Alert in
                Alert(
                    title: Text(alertError.title),
                    message: Text(alertError.message),
                    dismissButton: nil)
            })
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
