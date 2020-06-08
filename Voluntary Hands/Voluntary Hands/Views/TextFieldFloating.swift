//
//  TextFieldFloating.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct TextFieldFloating: View {
    
    // MARK: - Properties
    var placeholder: String
    var isSecure: Bool
    
    var onEditingChanged: (Bool) -> () = { _ in }
    var onCommit: () -> () = { }
    
    // MARK: - Binders
    @Binding var text: String
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .frame(height: 35)
                    .foregroundColor(ColorStyle.grayLight)
            } else {
                Text(placeholder)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .frame(height: 1)
                    .foregroundColor(ColorStyle.grayLight)
            }
            
            VStack(alignment: .leading) {
                
                if isSecure {
                    SecureField("", text: $text, onCommit: onCommit)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(ColorStyle.grayLight)
                        .frame(height: 35)
                    Divider()
                        .frame(height: 2)
                        .background(ColorStyle.grayLight)
                } else {
                    TextField("", text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(ColorStyle.grayLight)
                        .frame(height: 35)
                    Divider()
                        .frame(height: 2)
                        .background(ColorStyle.grayLight)
                }
                
            }
        }
    }
    
    // MARK: - Initializers
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
}

struct TextFieldFloating_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldFloating("PLACEHOLDER", text: .constant("a"))
    }
}
