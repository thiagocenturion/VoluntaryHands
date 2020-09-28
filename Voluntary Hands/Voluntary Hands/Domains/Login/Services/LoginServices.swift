//
//  LoginServices.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

protocol LoginServicesProtocol: class {
    var network: NetworkProtocol { get }
    
    func loginVolunteer(cpf: String, password: String) -> AnyPublisher<LoginResponse, Error>
    func loginInstitution(cnpj: String, password: String) -> AnyPublisher<LoginResponse, Error>
}

final class LoginServices: LoginServicesProtocol {
    
    // MARK: - Public properties
    let network: NetworkProtocol
    
    // MARK: - Initialization
    init(network: NetworkProtocol) {
        self.network = network
    }
}

// MARK: - Public methods
extension LoginServices {
    
    func loginVolunteer(cpf: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        let body = LoginVolunteer(cpf: cpf, password: password)
        
        return network.post(
            endpoint: Endpoint.login,
            token: nil,
            body: body
        )
    }
    
    func loginInstitution(cnpj: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        let body = LoginInstitution(cnpj: cnpj, password: password)
        
        return network.post(
            endpoint: Endpoint.login,
            token: nil,
            body: body
        )
    }
}
