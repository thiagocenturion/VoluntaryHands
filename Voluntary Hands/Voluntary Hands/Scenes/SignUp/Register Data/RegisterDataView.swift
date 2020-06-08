//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataView: View {
    var body: some View {
        NavigationView {
            VStack() {
                Text("Hello World")
            }
            .navigationBarTitle("CADASTRO", displayMode: .inline)
            .padding(27.5)
            .background(ColorStyle.grayDark)
        }
        .preferredColorScheme(.dark)
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterDataView()
    }
}
