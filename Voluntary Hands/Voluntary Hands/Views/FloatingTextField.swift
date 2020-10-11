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
    let title: LocalizedStringKey
    
    @Binding var text: String
    @Binding var error: String?
    
    let isSecure: Bool
    let onCommit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(currentColor)
                .offset(y: $text.wrappedValue.isEmpty ? 23 : 8)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
                .animation(.linear(duration: 0.2))
            textField
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.Style.grayLight)
            Divider()
                .frame(height: 2)
                .background(currentColor)
            Text(error ?? "")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.Style.red)
                .frame(height: 10)
        }
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
    
    private var currentColor: Color {
        return $error.wrappedValue != nil ? Color.Style.red :
            $text.wrappedValue.isEmpty ? Color.Style.grayLight : .accentColor
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            FloatingTextField(title: "CPF / CNPJ", text: .constant(""), error: .constant(nil), isSecure: false, onCommit: { })
            FloatingTextField(title: "CPF / CNPJ", text: .constant("Texto"), error: .constant(nil), isSecure: false, onCommit: { })
            FloatingTextField(title: "CPF / CNPJ", text: .constant(""), error: .constant("Mensagem de erro"), isSecure: false, onCommit: { })
            FloatingTextField(title: "CPF / CNPJ", text: .constant("Texto"), error: .constant("Mensagem de erro"), isSecure: false, onCommit: { })
        }
        .padding(.vertical, 1000)
        .background(Color.Style.grayDark)
    }
}

extension FloatingTextField {
    func mask(_ mask: String) -> some View {
        self.onReceive(Just(text)) { newValue in
            text = newValue.string(withMask: mask)
        }
    }
}
