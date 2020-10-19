//
//  RegisterDataContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct RegisterDataContainerView: View {
    @EnvironmentObject var store: Store<RegisterState, RegisterAction>
    
    @Binding var activeSheet: RegisterCoordinator.ActiveSheet?
    
    private var userType: Binding<UserType> {
        store.binding(for: \.userType) { .userType(type: $0) }
    }
    
    private var termsAccepted: Binding<Bool> {
        store.binding(for: \.termsAccepted) { .acceptTerms(isAccept: $0) }
    }
    
    var body: some View {
        RegisterDataView(
            image: UIImage(data: store.state.currentImage ?? Data()),
            userType: userType,
            termsAccepted: termsAccepted,
            loading: store.state.loading,
            onCommitSignUpVolunteer: { requestSignUp($0) },
            onCommitSignUpInstitution: { requestSignUp($0) },
            onCommitProfileImage: { activeSheet = .imagePicker },
            onCommitPrivacyPolicy: { activeSheet = .privacyPolicy },
            onCommitUseTerms: { activeSheet = .useTerms }
        )
        .onAppear(perform: {
            store.send(.resetState)
        })
    }
}

// MARK: - Requets

extension RegisterDataContainerView {
    
    private func requestSignUp(_ volunteer: RegisterVolunteer) {
        store.send(.signUpVolunteer(volunteer: volunteer))
    }
    
    private func requestSignUp(_ institution: RegisterInstitution) {
        store.send(.signUpInstitution(institution: institution))
    }
}


struct RegisterDataContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterDataContainerView(activeSheet: .constant(nil))
    }
}
