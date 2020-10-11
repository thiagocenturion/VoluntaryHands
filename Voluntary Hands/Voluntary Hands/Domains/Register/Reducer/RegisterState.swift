//
//  RegisterState.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import SwiftUI

struct FormItem: Codable, Hashable {
    var title: String
    var text = ""
    var errorMessage: String?
    
    let mask: String
    let keyboardType: Int
    let isSecure: Bool
}

struct FormItemRow: View {
    @Binding var item: FormItem
    
    var body: some View {
        FloatingTextField(
            title: LocalizedStringKey(item.title),
            text: $item.text,
            error: $item.errorMessage,
            isSecure: item.isSecure,
            onCommit: { }
        )
        .mask(item.mask)
        .keyboardType(UIKeyboardType(rawValue: item.keyboardType) ?? .default)
            
    }
}

struct RegisterState: Codable, Equatable {
    var volunteerForm: [FormItem] = []
    var loading = false
    var currentImage: Data?
    var userType: UserType = .volunteer
    var volunteer = RegisterVolunteer()
    var termsAccepted = false
    var registerSuccess = false
    var alert: AlertError?
}
