//
//  RegisterState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import SwiftUI

struct RegisterState: Codable, Equatable {
    var loading = false
    var currentImage: Data?
    var userType: UserType = .volunteer
    var termsAccepted = false
    var registerSuccess = false
    var alert: AlertError?
}
