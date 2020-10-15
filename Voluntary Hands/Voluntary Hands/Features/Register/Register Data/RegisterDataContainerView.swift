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
    
    private var userType: Binding<UserType> {
        store.binding(for: \.userType) { .userType(type: $0) }
    }
    
    private var alertShown: Binding<AlertError?> {
        store.binding(for: \.alert) { _ in .alert(error: nil) }
    }
    
    var body: some View {
        
        let image = Binding<UIImage?>(
            get: {
                if let data = store.state.currentImage {
                    return UIImage(data: data)
                } else {
                    return nil
                }
            },
            set: { image in store.send(.currentImage(data: image?.jpegData(compressionQuality: 0.3))) }
        )
        
        RegisterDataView(
            image: image,
            userType: userType,
            loading: store.state.loading,
            onCommitSignUpVolunteer: { requestSignUp($0) },
            onCommitSignUpInstitution: { requestSignUp($0) }
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
        RegisterDataContainerView()
    }
}
