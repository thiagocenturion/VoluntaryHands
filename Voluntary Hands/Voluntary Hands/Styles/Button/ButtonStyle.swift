//
//  ButtonStyle.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 10/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

enum ButtonThemeStyle {
    case primary(isDisabled: Bool)
    case secondary(color: Color)
}

extension View {
    func buttonStyle(_ style: ButtonThemeStyle) -> some View {
        switch style {
        case .primary(let isDisabled):
            return AnyView(buttonStyle(PrimaryBackgroundStyle(isDisabled: isDisabled)))
        case .secondary(let color):
            return AnyView(buttonStyle(SecondaryBackgroundStyle(color: color)))
        }
    }
}
