//
//  FormItem.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 12/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import SwiftUI

final class FormItem: Identifiable {
    typealias ValidationInText = (_ newValue: String) -> (errorMessage: String?, isValid: Bool)
    typealias MaskInText = (_ newValue: String) -> String
    
    let id = UUID()
    
    var title: String
    var text = ""
    var errorMessage: String?
    var maskInText: MaskInText?
    let keyboardType: UIKeyboardType
    var textContentType: UITextContentType?
    let isSecure: Bool
    var validateInText: ValidationInText
    var onCommit: () -> Void
    
    init(title: String,
         maskInText: MaskInText? = nil,
         keyboardType: UIKeyboardType = .default,
         textContentType: UITextContentType? = nil,
         isSecure: Bool,
         validateInText: @escaping ValidationInText = { _ in (nil, true) },
         onCommit: @escaping () -> Void = { }) {
        
        self.title = title
        self.maskInText = maskInText
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isSecure = isSecure
        self.validateInText = validateInText
        self.onCommit = onCommit
    }
}
