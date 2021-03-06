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
    typealias Validation = (_ newValue: String) -> ValidationText
    typealias Mask = (_ newValue: String) -> String
    
    let title: LocalizedStringKey
    
    @Binding var text: String
    @Binding var error: String?
    let isSecure: Bool
    var mask: Mask?
    var validate: Validation
    let onCommit: () -> Void
    
    var inputText: Binding<String> {
        Binding<String>(
            get: { text },
            set: {
                if let mask = mask {
                    let newValue = $0.string(withMask: mask($0))
                    error = validate(newValue).errorMessage

                    withAnimation(Animation.linear(duration: 0.2)) { text = newValue }
                } else {
                    error = validate($0).errorMessage
                    
                    let newValue = $0
                    withAnimation(Animation.linear(duration: 0.2)) { text = newValue }
                }
            }
        )
    }
    
    init(title: LocalizedStringKey,
         text: Binding<String>,
         error: Binding<String?> = .constant(nil),
         isSecure: Bool = false,
         mask: Mask? = nil,
         validate: @escaping Validation = { _ in .init(errorMessage: nil, isValid: true) },
         onCommit: @escaping () -> Void = { }) {
        
        self.title = title
        self._text = text
        self._error = error
        self.isSecure = isSecure
        self.mask = mask
        self.validate = validate
        self.onCommit = onCommit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(currentColor)
                .offset(y: $text.wrappedValue.isEmpty ? 23 : 8)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
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
    
    var textField: some View {
        Group {
            if isSecure {
                SecureField("", text: inputText, onCommit: onCommit)
            } else {
                TextField("", text: inputText, onCommit: onCommit)
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
            FloatingTextField(title: "CPF / CNPJ", text: .constant("123456"), error: .constant(nil), isSecure: false, mask: { _ in "999.999.999-99" }, onCommit: { })
            FloatingTextField(title: "CPF / CNPJ", text: .constant(""), error: .constant("Mensagem de erro"), isSecure: false, onCommit: { })
            FloatingTextField(title: "CPF / CNPJ", text: .constant("Texto"), error: .constant("Mensagem de erro"), isSecure: false, onCommit: { })
        }
        .padding(.vertical, 1000)
        .background(Color.Style.grayDark)
    }
}
