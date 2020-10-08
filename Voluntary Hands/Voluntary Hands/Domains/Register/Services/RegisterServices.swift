//
//  RegisterServices.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

protocol RegisterServicesType: class {
    var network: NetworkType { get }
    
    func register(with volunteer: RegisterVolunteer) -> AnyPublisher<String, Error>
}

final class RegisterServices: RegisterServicesType {
    // MARK: - Public properties
    let network: NetworkType
    
    // MARK: - Initialization
    init(network: NetworkType) {
        self.network = network
    }
}

// MARK: - Public methods
extension RegisterServices {
    
    func register(with volunteer: RegisterVolunteer) -> AnyPublisher<String, Error> {
        return network.requestString(
            endpoint: Endpoint.registerVolunteer,
            httpMethod: .post(body: volunteer),
            token: nil)
    }
}
