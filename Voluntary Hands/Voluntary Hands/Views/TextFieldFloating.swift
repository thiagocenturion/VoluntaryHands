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
    let onCommit: () -> Void
    
    var onEditingChanged: (Bool) -> () = { _ in }
    
    // MARK: - Binders
    @Binding var text: String
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .frame(height: 35)
                    .foregroundColor(Color.Style.grayLight)
            } else {
                Text(placeholder)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .frame(height: 1)
                    .foregroundColor(Color.Style.grayLight)
            }
            
            VStack(alignment: .leading) {
                
                if isSecure {
                    SecureField("", text: $text, onCommit: onCommit)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color.Style.grayLight)
                        .frame(height: 35)
                    Divider()
                        .frame(height: 2)
                        .background(Color.Style.grayLight)
                } else {
                    TextField("", text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color.Style.grayLight)
                        .frame(height: 35)
                    Divider()
                        .frame(height: 2)
                        .background(Color.Style.grayLight)
                }
                
            }
        }
    }
    
    // MARK: - Initializers
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false, onCommit: @escaping () -> Void) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.onCommit = onCommit
    }
}

struct TextFieldFloating_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldFloating("PLACEHOLDER", text: .constant("a"), onCommit: { })
    }
}
