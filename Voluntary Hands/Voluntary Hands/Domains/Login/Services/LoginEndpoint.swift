//
//  LoginEndpoint.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension Endpoint {
    static var login: Self {
        return Endpoint(path: "/login")
    }
}
