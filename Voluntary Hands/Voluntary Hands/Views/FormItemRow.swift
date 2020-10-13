//
//  FormItemRow.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 12/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct FormItemRow: View {
    @Binding var item: FormItem
    
    var body: some View {
        FloatingTextField(
            title: LocalizedStringKey(item.title),
            text: $item.text,
            error: $item.errorMessage,
            isSecure: item.isSecure,
            mask: item.maskInText,
            validate: item.validateInText,
            onCommit: item.onCommit
        )
        .keyboardType(item.keyboardType)
        .textContentType(item.textContentType)
            
    }
}

struct FormItemRow_Previews: PreviewProvider {
    static var previews: some View {
        FormItemRow(item: .constant(FormItem(title: "CPF", keyboardType: .numberPad, isSecure: false)))
    }
}
