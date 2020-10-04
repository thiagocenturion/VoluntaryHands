//
//  LoginReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

//extension Reducer {
//    static var loginReducer: Reducer<LoginState, LoginAction, LoginServicesEnvironmentType> {
//        return Reducer<LoginState, LoginAction, LoginServicesEnvironmentType> { state, action, environment in
//            switch action {
//            case .loginVolunteer(let cpf, let password):
//                return environment.loginServices.loginVolunteer(cpf: cpf, password: password)
//                    .map { _ in LoginAction.loginSuccess }
//                    .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
//                    .eraseToAnyPublisher()
//
//            case .loginInstitution(let cnpj, let password):
//                return environment.loginServices.loginInstitution(cnpj: cnpj, password: password)
//                    .map { _ in LoginAction.loginSuccess }
//                    .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
//                    .eraseToAnyPublisher()
//
//            case .loginSuccess:
//                state.loginSuccess = true
//
//            case .alert(let error):
//                state.alert = "Não foi possível realizar o login"
//
//            case .removeAlert:
//                state.alert = nil
//
//            case .set(let newState):
//                state = newState
//
//            case .resetState:
//                state.currentUsername = ""
//                state.currentPassword = ""
//                state.loginSuccess = false
//                state.alert = nil
//            }
//
//            return Empty(completeImmediately: true).eraseToAnyPublisher()
//        }
//    }
//}

let loginReducer: Reducer<LoginState, LoginAction, LoginServicesEnvironmentType> = Reducer { state, action, environment in
    switch action {
    case .signIn(let username, let password):
        if username.count == 11 {
            return environment.loginServices.loginVolunteer(cpf: username, password: password)
                .map { _ in LoginAction.loginSuccess }
                .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
                .eraseToAnyPublisher()
        } else if username.count == 16 {
            return environment.loginServices.loginInstitution(cnpj: username, password: password)
                .map { _ in LoginAction.loginSuccess }
                .catch { error in Just<LoginAction>(LoginAction.alert(error: error)) }
                .eraseToAnyPublisher()
        }
        
    case .loginSuccess:
        state.loginSuccess = true
        
    case .alert(let error):
        state.alert = "Não foi possível realizar o login"
        
    case .removeAlert:
        state.alert = nil
        
    case .set(let newState):
        state = newState
        
    case .resetState:
        state.loginSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
