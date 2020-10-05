//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: RegisterDataViewModel
    
    // MARK: - View
    var body: some View {
            VStack() {
                VStack(alignment: .trailing, spacing: 15) {
                    TextFieldFloating("EMAIL", text: $viewModel.email, onCommit: { })
                    TextFieldFloating("CONFIRMAÇÃO DE EMAIL", text: $viewModel.emailConfirm, onCommit: { })
                    TextFieldFloating("SENHA", text: $viewModel.password, isSecure: true, onCommit: { })
                    TextFieldFloating("CONFIRMAÇÃO DE SENHA", text: $viewModel.passwordConfirm, isSecure: true, onCommit: { })
                }
                
                Spacer()
                
                Button(action: { }) {
                    HStack {
                        Spacer()
                        Text("PRÓXIMO")
                        Spacer()
                    }
                }
                .buttonStyle(SecondaryBackgroundStyle(color: Color.Style.red))
            }
            .navigationBarTitle("CADASTRO", displayMode: .inline)
            .padding(27.5)
            .background(Color.Style.grayDark)
            .preferredColorScheme(.dark)
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterDataView(viewModel: RegisterDataViewModel())
        }
    }
}
