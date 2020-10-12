//
//  FormItem.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 12/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

final class FormItem: Identifiable {
    let id = UUID()
    
    var title: String
    var text = ""
    var errorMessage: String?
    var mask: String?
    let keyboardType: Int
    let isSecure: Bool
    
    init(title: String,
         mask: String?,
         keyboardType: Int,
         isSecure: Bool) {
        
        self.title = title
        self.mask = mask
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }
}
