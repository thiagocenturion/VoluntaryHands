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
    let counter = AppLaunchCounter()
    let files = FileManager.default
    let network = Network(
        session: .shared,
        decoder: .init(),
        encoder: .init(),
        timeout: 30,
        monitor: .init(),
        tokenUpdater: TokenUpdater(userDefaults: UserDefaults.standard))
}
