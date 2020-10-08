//
//  LoginAction.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

enum LoginAction {
    case signIn(username: String, password: String)
    case loginSuccess
    case alert(error: Error?)
    case set(state: LoginState)
    case resetState
}
