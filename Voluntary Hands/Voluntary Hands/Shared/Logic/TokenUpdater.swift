//
//  TokenUpdater.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 02/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

final class TokenUpdater {
    
    // MARK: - Public properties
    let userDefaults: UserDefaults
    
    var token: String? {
        get {
            return userDefaults.string(forKey: #function)
        }
        
        set {
            userDefaults.set(newValue, forKey: #function)
        }
    }
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

#if UNIT_TEST

extension TokenUpdater {
    
    static func mock(userDefaults: UserDefaults = .standard) -> TokenUpdater {
        return TokenUpdater(userDefaults: userDefaults)
    }
}

#endif
