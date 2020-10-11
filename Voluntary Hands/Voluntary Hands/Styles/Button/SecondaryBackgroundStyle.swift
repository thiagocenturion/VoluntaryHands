//
//  SecondaryBackgroundStyle.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SecondaryBackgroundStyle: ButtonStyle {
    // MARK: - Properties
    let color: Color
    
    // MARK: - View
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(color)
            .frame(height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(color, lineWidth: 2.5)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SecondaryBackgroundStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { }) {
            HStack {
                Spacer()
                Text("CADASTRE-SE")
                Spacer()
            }
        }
        .buttonStyle(.secondary(color: Color.Style.blue))
    }
}
