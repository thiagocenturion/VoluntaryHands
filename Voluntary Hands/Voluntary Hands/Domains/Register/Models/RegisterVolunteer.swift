//
//  RegisterVolunteer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

final class RegisterVolunteer: Codable {
    var cpf = ""
    var email = ""
    var firstName = ""
    var lastName = ""
    var cellphone = ""
    
    /// dd-MM-yyyy
    var birthdate: Date?
    
    /// SP, RJ, RS, etc
    var state = ""
    var city = ""
    var password = ""
    var confirmPassword = ""
    
    private enum CodingKeys: String, CodingKey {
        case cpf = "cpf"
        case email = "email"
        case firstName = "nome"
        case lastName = "ultimoSobrenome"
        case cellphone = "celular"
        case birthdate = "dataDeNascimento"
        case state = "estado"
        case city = "cidade"
        case password = "senha"
    }
}

extension RegisterVolunteer {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cpf, forKey: .cpf)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(cellphone, forKey: .cellphone)
        
        let birthdateString = DateFormatter.dayMonthYear.string(from: birthdate!)
        try container.encode(birthdateString, forKey: .birthdate)
        
        try container.encode(state, forKey: .state)
        try container.encode(city, forKey: .city)
        try container.encode(password, forKey: .password)
    }
}

extension RegisterVolunteer: Equatable {
    
    static func == (lhs: RegisterVolunteer, rhs: RegisterVolunteer) -> Bool {
        return lhs.cpf == rhs.cpf &&
            lhs.email == rhs.email &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.cellphone == rhs.cellphone &&
            lhs.birthdate == rhs.birthdate &&
            lhs.state == rhs.state &&
            lhs.city == rhs.city &&
            lhs.password == rhs.password
    }
}
