//
//  LinearGradient+Extension.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    static func blue(isDisabled: Bool = false) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                                isDisabled ? .clear : Color.Style.blue,
                                isDisabled ? .clear : Color.Style.blueLight]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
