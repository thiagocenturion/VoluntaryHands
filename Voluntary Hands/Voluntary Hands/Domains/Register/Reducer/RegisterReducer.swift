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
        
    case .volunteer(let cpf, let email, let firstName, let lastName, let cellphone, let birthdate, let federalState, let city, let password, let confirmPassword):
        
        if let cpf = cpf { state.volunteer.cpf = cpf }
        if let email = email { state.volunteer.email = email }
        if let firstName = firstName { state.volunteer.firstName = firstName }
        if let lastName = lastName { state.volunteer.lastName = lastName }
        if let cellphone = cellphone { state.volunteer.cellphone = cellphone }
        if let birthdate = birthdate { state.volunteer.birthdate = birthdate }
        if let federalState = federalState { state.volunteer.state = federalState }
        if let city = city { state.volunteer.city = city }
        if let password = password { state.volunteer.password = password }
        if let confirmPassword = confirmPassword { state.volunteer.confirmPassword = confirmPassword }
        
    case .acceptTerms(let isAccept):
        state.termsAccepted = isAccept
        
    case .signUp:
        state.loading = true
        
        return environment.registerServices.register(with: state.volunteer)
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
        state.volunteer = RegisterVolunteer()
        state.termsAccepted = false
        state.registerSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
