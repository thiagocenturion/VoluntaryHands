//
//  RegisterInstitution.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 15/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct RegisterInstitution: Codable {
    var cnpj = ""
    var email = ""
    var companyName = ""
    var tradingName = ""
    var cellphone = ""
    
    /// SP, RJ, RS, etc
    var state = ""
    var city = ""
    var password = ""
    var confirmPassword = ""
    var objectives = ""
    
    private enum CodingKeys: String, CodingKey {
        case cnpj = "cnpj"
        case email = "email"
        case companyName = "razaoSocial"
        case tradingName = "nomeFantasia"
        case cellphone = "celular"
        case state = "estado"
        case city = "cidade"
        case password = "senha"
        case objectives = "objetivos"
    }
}

extension RegisterInstitution {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cnpj, forKey: .cnpj)
        try container.encode(email, forKey: .email)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(tradingName, forKey: .tradingName)
        try container.encode(cellphone, forKey: .cellphone)
        try container.encode(state, forKey: .state)
        try container.encode(city, forKey: .city)
        try container.encode(password, forKey: .password)
        try container.encode(objectives, forKey: .objectives)
    }
}

extension RegisterInstitution: Equatable {
    
    static func == (lhs: RegisterInstitution, rhs: RegisterInstitution) -> Bool {
        return lhs.cnpj == rhs.cnpj &&
            lhs.email == rhs.email &&
            lhs.companyName == rhs.companyName &&
            lhs.tradingName == rhs.tradingName &&
            lhs.cellphone == rhs.cellphone &&
            lhs.state == rhs.state &&
            lhs.city == rhs.city &&
            lhs.password == rhs.password &&
            lhs.objectives == rhs.objectives
    }
}
