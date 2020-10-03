//
//  AppReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

//extension Reducer {
//    static var appReducer: Reducer<AppState, AppAction, AppEnvironment> {
//        return Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
//            switch action {
//            case .login(action: let action):
//                return Self.loginReducer(&state.login, action, environment)
//                    .map { AppAction.login(action: $0) }
//                    .eraseToAnyPublisher()
//            }
//
//            return Empty(completeImmediately: true).eraseToAnyPublisher()
//        }
//    }
//}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer { state, action, environment in
    switch action {
    case .login(action: let action):
        return loginReducer(&state.login, action, environment)
            .map { AppAction.login(action: $0) }
            .eraseToAnyPublisher()
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
