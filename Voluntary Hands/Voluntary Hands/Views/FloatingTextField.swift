//
//  FloatingTextField.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 05/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct FloatingTextField: View {
    let title: String
    
    @Binding var text: String
    
    let isSecure: Bool
    let onCommit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor($text.wrappedValue.isEmpty ? Color.Style.grayLight : .accentColor)
                .offset(y: $text.wrappedValue.isEmpty ? 20 : 0)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
            textField
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.Style.grayLight)
            Divider()
                .frame(height: 2)
                .background($text.wrappedValue.isEmpty ? Color.Style.grayLight : .accentColor)
        }
        .animation(.default)
//        .animation(.spring(response: 0.2, dampingFraction: 0.5))
    }
    
    private var textField: some View {
        Group {
            if isSecure {
                SecureField("", text: $text, onCommit: onCommit)
            } else {
                TextField("", text: $text, onCommit: onCommit)
            }
        }
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        FloatingTextField(title: "CPF / CNPJ", text: .constant(""), isSecure: false, onCommit: { })
    }
}

extension FloatingTextField {
    func mask(_ mask: String) -> some View {
        self.onReceive(Just(text)) { newValue in
            text = newValue.string(withMask: mask)
        }
    }
}
