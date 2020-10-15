//
//  RegisterEndpoint.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension Endpoint {
    static var registerVolunteer: Self {
        return Endpoint(path: "/new_volunteer")
    }
    
    static var registerInstitution: Self {
        return Endpoint(path: "/new_institution")
    }
}
