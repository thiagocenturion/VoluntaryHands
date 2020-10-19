//
//  SocialCausesServices.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

protocol SocialCausesServicesType: class {
    var network: NetworkType { get }
    
    func causes() -> AnyPublisher<CausesResponse, Error>
    func save(causesSelected: [Cause]) -> AnyPublisher<String, Error>
}

final class SocialCausesServices: SocialCausesServicesType {
    let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
}

extension SocialCausesServices {
    
    func causes() -> AnyPublisher<CausesResponse, Error> {
        return network.request(
            endpoint: Endpoint.causes,
            httpMethod: .get,
            authorizationIfNeeded: true
        )
    }
    
    func save(causesSelected: [Cause]) -> AnyPublisher<String, Error> {
        return network.requestString(
            endpoint: Endpoint.saveCauses,
            httpMethod: .post(body: causesSelected),
            authorizationIfNeeded: true
        )
    }
}
