//
//  StringLimit.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 12/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

class StringLimit: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    var characterLimit: Int

    init(text: String, limit: Int = 5) {
        self.text = text
        characterLimit = limit
    }
}
