//
//  FullWidthButton.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 10/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct FullWidthButton: View {
    let titleKey: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(titleKey)
                Spacer()
            }
        }
    }
}

struct FullWidthButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FullWidthButton(titleKey: "LOGIN", action: { })
                .buttonStyle(.primary(isDisabled: false))
        }.background(Color.Style.grayDark)
    }
}
