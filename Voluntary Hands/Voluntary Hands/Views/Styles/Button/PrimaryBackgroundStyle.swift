//
//  ButtonRounded.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct PrimaryBackgroundStyle: ButtonStyle {
    
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .padding()
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                                        isDisabled ? .clear : Color.Style.blue,
                                        isDisabled ? .clear : Color.Style.blueLight]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isDisabled ? Color.white : Color.clear, lineWidth: 2.5)
            )
            .opacity(isDisabled ? 0.2 : 1.0)
            .frame(height: 50)
            .cornerRadius(25)
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 10, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .disabled(isDisabled)
    }
}

struct PrimaryBackgroundStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: { }) {
                HStack {
                    Spacer()
                    Text("CADASTRE-SE")
                    Spacer()
                }
            }
            .buttonStyle(.primary(isDisabled: false))
            
            Button(action: { }) {
                HStack {
                    Spacer()
                    Text("CADASTRE-SE")
                    Spacer()
                }
            }
            .buttonStyle(.primary(isDisabled: true))
        }
        .padding(.vertical, 1000)
        .background(Color.Style.grayDark)
    }
}
