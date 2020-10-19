//
//  LoginReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import UIKit
import Combine

let loginReducer: Reducer<LoginState, LoginAction, LoginServicesEnvironmentType> = Reducer { state, action, environment in
    switch action {
    case .signIn(let username, let password):
        state.loading = true
        
        let username = username.onlyNumbers
        let password = password
        
        if username.isCPF {
            
            return environment.loginServices.loginVolunteer(cpf: username, password: password)
                .map { _ in LoginAction.loginSuccess }
                .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
                .eraseToAnyPublisher()
            
        } else if username.isCNPJ {
            
            return environment.loginServices.loginInstitution(cnpj: username, password: password)
                .map { _ in LoginAction.loginSuccess }
                .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
                .eraseToAnyPublisher()

        }
        
    case .loginSuccess:
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        state.loading = false
        state.loginSuccess = true
        
    case .alert(let error):
        state.loading = false
        
        guard let error = error else {
            state.alert = nil
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        var alertError: AlertError?
        if let networkingError = error as? NetworkingError {
            switch networkingError {
            case .serverErrorMessage(let message):
                alertError = .init(title: "Puxa!", message: message ?? "Houve um problema no login. Tente novamente")
            default:
                alertError = .init(title: "Oops!", message: "Não foi possível realizar o login")
            }
        } else {
            alertError = .init(title: "Oops!", message: "Não foi possível realizar o login")
        }
        
        state.alert = alertError
        
    case .set(let newState):
        state = newState
        
    case .resetState:
        state.loading = false
        state.loginSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
