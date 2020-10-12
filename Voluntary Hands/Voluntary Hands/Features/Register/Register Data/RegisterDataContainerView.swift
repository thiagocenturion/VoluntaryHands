//
//  RegisterDataContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataContainerView: View {
    @EnvironmentObject var store: Store<RegisterState, RegisterAction>
    
    @State private var volunteerForm = [
        FormItem(title: "CPF", mask: "999.999.999-99", keyboardType: UIKeyboardType.numberPad.rawValue, isSecure: false)
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
