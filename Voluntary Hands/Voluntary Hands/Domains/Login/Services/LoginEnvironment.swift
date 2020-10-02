//
//  LoginEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

protocol LoginEnvironmentProtocol {
    var loginServices: LoginServicesProtocol { get }
}

extension AppEnvironment: LoginEnvironmentProtocol {
    var loginServices: LoginServicesProtocol {
        LoginServices(network: network)
    }
}
