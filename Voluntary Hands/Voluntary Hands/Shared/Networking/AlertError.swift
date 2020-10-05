//
//  AlertError.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 05/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct AlertError: Identifiable, Codable, Equatable {
    var id = UUID()
    let title: String
    let message: String
}
