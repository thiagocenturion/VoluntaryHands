//
//  AppReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer { state, action, environment in
    switch action {
    case .login(let action):
        return loginReducer(&state.login, action, environment)
            .map { AppAction.login(action: $0) }
            .eraseToAnyPublisher()
        
    case .register(let action):
        return registerReducer(&state.register, action, environment)
            .map { AppAction.register(action: $0) }
            .eraseToAnyPublisher()
        
    case .socialCauses(action: let action):
        return socialCausesReducer(&state.socialCauses, action, environment)
            .map { AppAction.socialCauses(action: $0) }
            .eraseToAnyPublisher()
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
