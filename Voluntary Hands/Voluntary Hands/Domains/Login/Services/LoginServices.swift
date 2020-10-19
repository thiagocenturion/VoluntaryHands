//
//  LoginServices.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

protocol LoginServicesType: class {
    var network: NetworkType { get }
    
    func loginVolunteer(cpf: String, password: String) -> AnyPublisher<String, Error>
    func loginInstitution(cnpj: String, password: String) -> AnyPublisher<String, Error>
}

final class LoginServices: LoginServicesType {
    
    // MARK: - Public properties
    let network: NetworkType
    
    // MARK: - Initialization
    init(network: NetworkType) {
        self.network = network
    }
}

// MARK: - Public methods
extension LoginServices {
    
    func loginVolunteer(cpf: String, password: String) -> AnyPublisher<String, Error> {
        return network.requestString(
            endpoint: Endpoint.login,
            httpMethod: .post(body: LoginVolunteer(cpf: cpf, password: password)),
            authorizationIfNeeded: false)
    }
    
    func loginInstitution(cnpj: String, password: String) -> AnyPublisher<String, Error> {
        return network.requestString(
            endpoint: Endpoint.login,
            httpMethod: .post(body: LoginInstitution(cnpj: cnpj, password: password)),
            authorizationIfNeeded: false)
    }
}
