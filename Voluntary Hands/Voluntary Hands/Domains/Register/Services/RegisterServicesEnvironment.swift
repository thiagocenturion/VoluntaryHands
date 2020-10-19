//
//  RegisterServicesEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol RegisterServicesEnvironmentType {
    var remoteStorage: Storage { get }
    var registerServices: RegisterServicesType { get }
}

extension AppEnvironment: RegisterServicesEnvironmentType {
    var registerServices: RegisterServicesType {
        RegisterServices(network: network)
    }
}
