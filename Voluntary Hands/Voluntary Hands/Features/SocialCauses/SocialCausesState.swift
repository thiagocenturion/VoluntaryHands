//
//  SocialCausesState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SocialCausesState: Codable, Equatable {
    var loading = false
    var causes: [Cause] = []
    var causesSelected: [Cause] = []
    var getCausesSuccess = false
    var savingSuccess = false
    var multiSelection = true
    var alert: AlertError?
}
