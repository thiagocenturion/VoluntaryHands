//
//  SocialCausesState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SocialCausesState: Codable, Equatable {
    
    enum LoadingType: String, Codable, Equatable {
        case opaque
        case transparent
        case none
    }
    
    var loading: LoadingType = .none
    var causes: [Cause] = []
    var causesSelected: [Cause] = []
    var getCausesSuccess = false
    var savingSuccess = false
    var multiSelection = true
    var alert: AlertError?
}
