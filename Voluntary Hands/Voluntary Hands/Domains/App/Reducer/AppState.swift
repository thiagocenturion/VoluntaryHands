//
//  AppState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct AppState: Codable, Equatable {
    /// TODO: Utilizar uma Model `User`, que possua os dados de usuário necessários ao longo do app (username, e nome completo, por exemplo) + token para requisições
    var currentUser = ""
    
    var login: LoginState = LoginState()
}
