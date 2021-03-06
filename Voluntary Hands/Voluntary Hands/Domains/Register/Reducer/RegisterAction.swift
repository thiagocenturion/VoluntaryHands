//
//  RegisterAction.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 08/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

enum RegisterAction {
    case currentImage(data: Data?)
    case userType(type: UserType)
    case acceptTerms(isAccept: Bool)
    case signUpVolunteer(volunteer: RegisterVolunteer)
    case signUpInstitution(institution: RegisterInstitution)
    case registerSuccess
    case alert(error: Error?)
    case set(state: RegisterState)
    case resetState
}
