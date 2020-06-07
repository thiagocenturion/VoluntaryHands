//
//  ButtonRounded.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct PrimaryBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [ColorStyle.blue, ColorStyle.blueLight]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 50)
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct PrimaryBackgroundStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { }) {
            HStack {
                Spacer()
                Text("CADASTRE-SE")
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
        .buttonStyle(PrimaryBackgroundStyle())
    }
}
