//
//  RegisterReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 08/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

let registerReducer: Reducer<RegisterState, RegisterAction, RegisterServicesEnvironmentType> = Reducer { state, action, environment in
    switch action {
    case .currentImage(let data):
        state.currentImage = data
        
    case .userType(let type):
        state.userType = type
        
    case .acceptTerms(let isAccept):
        state.termsAccepted = isAccept
        
    case .signUpVolunteer(let volunteer):
        state.loading = true
        
        return environment.registerServices.register(with: volunteer)
            .map { _ in RegisterAction.registerSuccess }
            .catch { error in Just<RegisterAction>(RegisterAction.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .registerSuccess:
        state.loading = false
        state.registerSuccess = true
        
    case .alert(error: let error):
        state.loading = false
        
        var alertError: AlertError?
        if let networkingError = error as? NetworkingError {
            switch networkingError {
            case .serverErrorMessage(let message):
                alertError = .init(title: "Puxa!", message: message ?? "Houve um problema no cadastro. Tente novamente")
            default:
                alertError = .init(title: "Oops!", message: "Não foi possível realizar o cadastro. Tente novamente.")
            }
        } else {
            alertError = error != nil ? .init(title: "Oops!", message: "Não foi possível realizar o cadastro. Tente novamente.") : nil
        }
        
        state.alert = alertError
        
    case .set(let newState):
        state = newState
        
    case .resetState:
        state.loading = false
        state.currentImage = nil
        state.userType = .volunteer
        state.termsAccepted = false
        state.registerSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
