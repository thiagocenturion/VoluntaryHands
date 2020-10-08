//
//  RegisterAction.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 08/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import SwiftUI

enum RegisterAction {
    case currentImage(image: UIImage?)
    case userType(type: UserType)
    
    case volunteer(cpf: String? = nil,
                   email: String? = nil,
                   firstName: String? = nil,
                   lastName: String? = nil,
                   cellphone: String? = nil,
                   birthdate: Date? = nil,
                   federalState: String? = nil,
                   city: String? = nil,
                   password: String? = nil)
    
    case acceptTerms(isAccept: Bool)
    case signUp
    case registerSuccess
    case alert(error: Error?)
    case set(state: RegisterState)
    case resetState
}
