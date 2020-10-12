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
    
    @State private var volunteerForm = [
        FormItem(
            title: "CPF", maskInText: { _ in "999.999.999-99" }, keyboardType: .numberPad, isSecure: false, validateInText: { text in
                if text.isEmpty {
                    return (errorMessage: nil, isValid: false)
                } else if !text.isCPF {
                    return (errorMessage: "O CPF digitado é inválido.", isValid: false)
                } else {
                    return (errorMessage: nil, isValid: true)
                }
            })
    ]
    
    @State private var signUpEnabled = false
    
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
            volunteerForm: $volunteerForm,
            signInEnabled: $signUpEnabled,
            onCommitSignUp: requestSignUp)
            .onReceive(Just(volunteerForm)) { volunteerForm in
                signUpEnabled = volunteerForm.map { $0.validateInText($0.text).isValid }.reduce(&&)
            }
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
    
    private func requestSignUp() {
        store.send(.signUp)
    }
}


struct RegisterDataContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterDataContainerView()
    }
}
