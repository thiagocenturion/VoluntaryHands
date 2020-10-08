//
//  LoginServicesEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

protocol LoginServicesEnvironmentType {
    var loginServices: LoginServicesType { get }
}

extension AppEnvironment: LoginServicesEnvironmentType {
    var loginServices: LoginServicesType {
        LoginServices(network: network)
    }
}
