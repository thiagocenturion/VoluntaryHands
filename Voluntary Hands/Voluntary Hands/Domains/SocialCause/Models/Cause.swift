//
//  Cause.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct Cause: Identifiable, Codable, Equatable {
    let id: Int
    let cause: String
    let iconUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case cause = "causa"
        case iconUrl = "iconeUrl"
    }
    
    init(id: Int, cause: String, iconUrl: String) {
        self.id = id
        self.cause = cause
        self.iconUrl = iconUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        cause = try container.decode(String.self, forKey: .cause)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cause, forKey: .cause)
        try container.encode(iconUrl, forKey: .iconUrl)
    }
}
