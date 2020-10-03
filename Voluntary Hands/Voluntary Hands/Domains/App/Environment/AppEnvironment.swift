//
//  AppEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Network

struct AppEnvironment {
    
    // MARK: - Public properties
    let counter: LaunchCounter
    let files: FileManager
    let network: NetworkType
//    let counter = LaunchCounter()
//    let files = FileManager.default
//    let network = Network(
//        session: .shared,
//        decoder: .init(),
//        encoder: .init(),
//        timeout: 30,
//        monitor: .init(),
//        tokenUpdater: TokenUpdater(userDefaults: UserDefaults.standard)
//    )
    
    // MARK: - Initialization
    init(counter: LaunchCounter,
         files: FileManager,
         network: NetworkType) {
        self.counter = counter
        self.files = files
        self.network = network
    }
}

#if UNIT_TEST

extension AppEnvironment {
    
    static func mock(counter: LaunchCounter = .init(),
                     files: FileManager = .default,
                     network: NetworkType = Network.mock()) -> AppEnvironment {
        
        return AppEnvironment(
            counter: counter,
            files: files,
            network: network
        )
    }
}

#endif
