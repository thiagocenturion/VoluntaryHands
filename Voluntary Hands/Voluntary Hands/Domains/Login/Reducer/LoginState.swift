//
//  LoginState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct LoginState: Codable, Equatable {
    var currentUsername = ""
    var currentPassword = ""
    var loginSuccess = false
    var alert: String?
}
