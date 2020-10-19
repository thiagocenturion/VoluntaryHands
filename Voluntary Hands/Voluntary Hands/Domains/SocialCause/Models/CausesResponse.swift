//
//  CausesResponse.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

struct CausesResponse: Decodable {
    let causes: [Cause]
    let causesSelected: [Cause]
    
    enum CodingKeys: String, CodingKey {
        case causes = "causas"
        case causesSelected = "causasSelecionadas"
    }
    
    init(causes: [Cause], causesSelected: [Cause]) {
        self.causes = causes
        self.causesSelected = causesSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        causes = try container.decode([Cause].self, forKey: .causes)
        
        if container.contains(.causesSelected) {
            causesSelected = try container.decode([Cause].self, forKey: .causesSelected)
        } else {
            causesSelected = []
        }
    }
}
