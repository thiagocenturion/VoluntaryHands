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
    case .update(let volunteerForm):
        state.volunteerForm = volunteerForm
    
    case .currentImage(let data):
        state.currentImage = data
        
    case .userType(let type):
        state.userType = type
        
    case .acceptTerms(let isAccept):
        state.termsAccepted = isAccept
        
    case .signUp:
        state.loading = true
        
        switch state.userType {
        case .volunteer:
            return environment.registerServices.register(with: state.volunteer)
                .map { _ in RegisterAction.registerSuccess }
                .catch { error in Just<RegisterAction>(RegisterAction.alert(error: error)) }
                .eraseToAnyPublisher()
        case .institution:
            // TODO: We will add a context here next feature branch
            break
        }
        
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
        state.volunteer = RegisterVolunteer()
        state.termsAccepted = false
        state.registerSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
