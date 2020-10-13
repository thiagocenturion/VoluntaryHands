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
    
    @State private var volunteerHeaderForm = [
        FormItem(
            title: "CPF", maskInText: { _ in "999.999.999-99" }, keyboardType: .numberPad, textContentType: .username, isSecure: false, validateInText: { text in
                if text.isEmpty {
                    return .init(errorMessage: nil, isValid: false)
                } else if !text.isCPF {
                    return .init(errorMessage: "O CPF digitado é inválido.", isValid: false)
                }
                
                return .init(errorMessage: nil, isValid: true)
            }),
        FormItem(title: "E-MAIL", keyboardType: .emailAddress, textContentType: .emailAddress, isSecure: false, validateInText: { text in
            if text.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if !text.isEmail {
                return .init(errorMessage: "O e-mail digitado é inválido.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
        })
    ]
    
    @State private var volunteerBodyForm = [
        FormItem(title: "PRIMEIRO NOME", textContentType: .name, isSecure: false, validateInText: { .init(errorMessage: nil, isValid: !$0.isEmpty) }),
        FormItem(title: "SOBRENOME", textContentType: .middleName, isSecure: false, validateInText: { .init(errorMessage: nil, isValid: !$0.isEmpty) }),
        FormItem(title: "CELULAR", maskInText: { _ in "(99) 99999-9999"}, keyboardType: .numberPad, textContentType: .telephoneNumber, isSecure: false, validateInText: { text in
            if text.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if !text.isPhoneNumber {
                return .init(errorMessage: "O celular digitado é inválido.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
        }),
        // TODO: Adicionar date picker para data de nascimento!
        // TODO: Adicionar picker para Estado
        // TODO: Adicionar picker para Cidade
        FormItem(title: "SENHA", textContentType: .newPassword, isSecure: true, validateInText: { text in
            if text.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if text.count < 8 {
                return .init(errorMessage: "A senha deve conter ao menos 8 caracteres.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
        }),
        FormItem(title: "CONFIRMAÇÃO DE SENHA", keyboardType: .webSearch, textContentType: .password, isSecure: true)
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
            volunteerHeaderForm: $volunteerHeaderForm,
            volunteerBodyForm: $volunteerBodyForm,
            signInEnabled: $signUpEnabled,
            onCommitSignUp: requestSignUp)
            .onAppear {
                volunteerBodyForm.last?.validateInText = { text in
                    if text.isEmpty {
                        return .init(errorMessage: nil, isValid: false)
                    } else if text != volunteerBodyForm[volunteerBodyForm.count - 2].text {
                        return .init(errorMessage: "Precisar ser igual à senha digitada.", isValid: false)
                    }
                    
                    return .init(errorMessage: nil, isValid: true)
                }
            }
            .onReceive(Publishers.CombineLatest(Just(volunteerHeaderForm), Just(volunteerBodyForm))) { headerForm, bodyForm in
                let all = Array([headerForm, bodyForm].joined())
                signUpEnabled = all.map { $0.validateInText($0.text).isValid }.reduce(&&)
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
