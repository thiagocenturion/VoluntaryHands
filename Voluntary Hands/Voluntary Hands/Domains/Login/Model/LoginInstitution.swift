//
//  LoginInstitution.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct LoginInstitution: Encodable {
    let cnpj: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case cnpj
        case password = "senha"
    }
}
