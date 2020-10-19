//
//  SocialCausesServicesEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

protocol SocialCausesServicesEnvironmentType {
    var socialCausesServices: SocialCausesServicesType { get }
}

extension AppEnvironment: SocialCausesServicesEnvironmentType {
    var socialCausesServices: SocialCausesServicesType {
        SocialCausesServices(network: network)
    }
}
