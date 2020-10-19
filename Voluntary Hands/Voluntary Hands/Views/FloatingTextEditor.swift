//
//  FloatingTextEditor.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct FloatingTextEditor: View {
    typealias Validation = (_ newValue: String) -> ValidationText
    typealias Mask = (_ newValue: String) -> String
    
    let title: LocalizedStringKey
    
    @Binding var text: String
    @Binding var error: String?
    var mask: Mask?
    var validate: Validation
    
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
         mask: Mask? = nil,
         validate: @escaping Validation = { _ in .init(errorMessage: nil, isValid: true) }) {
        
        self.title = title
        self._text = text
        self._error = error
        self.mask = mask
        self.validate = validate
        
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(currentColor)
                .offset(y: $text.wrappedValue.isEmpty ? 33 : 15)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
            ZStack(alignment: .topLeading) {
                TextEditor(text: inputText)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color.Style.grayLight)
                    .background(Color.clear)
                    .frame(minHeight: 23)
                    .offset(x: -4)
                    .ignoresSafeArea(.keyboard, edges: .bottom)                
                // This invisble text creates dynamic growing height
                Text(text)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .offset(y: -4)
                    .padding(.vertical, 4)
                    .opacity(0)
            }
            Divider()
                .frame(height: 2)
                .background(currentColor)
            Text(error ?? "")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.Style.red)
                .frame(height: 10)
        }
    }
    
    private var currentColor: Color {
        return $error.wrappedValue != nil ? Color.Style.red :
            $text.wrappedValue.isEmpty ? Color.Style.grayLight : .accentColor
    }
}

struct FloatingTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        let bigText = "A campanha é isso, é aquilo e tudo mais! \nA campanha é isso, é aquilo e tudo mais! \nA campanha é isso, é aquilo e tudo mais!"
        
        VStack {
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant(""), error: .constant(nil))
            
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant("A campanha é isso, é aquilo e tudo mais!"), error: .constant(nil))
            
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant(bigText), error: .constant(nil))
            
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant(""), error: .constant("Mensagem de erro"))
            
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant("A campanha é isso, é aquilo e tudo mais!"), error: .constant("Mensagem de erro"))
            
            FloatingTextEditor(title: "OBJETIVO DA CAMPANHA", text: .constant(bigText), error: .constant("Mensagem de erro"))
        }
        .padding(.vertical, 1000)
        .background(Color.Style.grayDark)
    }
}
