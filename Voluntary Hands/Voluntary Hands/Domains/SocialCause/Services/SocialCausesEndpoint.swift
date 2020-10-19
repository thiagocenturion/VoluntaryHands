//
//  SocialCausesEndpoint.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension Endpoint {
    static var causes: Self {
        return Endpoint(path: "/causes")
    }
    
    static var saveCauses: Self {
        return Endpoint(path: "/save_causes")
    }
    
    static var newCauses: Self {
        return Endpoint(path: "/new_causes")
    }
}
