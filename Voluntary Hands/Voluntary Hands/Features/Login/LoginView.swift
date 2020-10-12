//
//  LoginView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    // MARK: - Properties
    @Binding var formItems: [FormItem]
    @Binding var signInEnabled: Bool
    
    var loading: Bool
    
    let onCommitSignIn: () -> Void
    let onCommitSignUp: () -> Void
    let onCommitForgotPassword: () -> Void

    // MARK: - View
    
    var body: some View {
            ZStack {
                if loading {
                    ActivityView()
                    content.opacity(0.3)
                } else {
                    content
                }
            }
            .padding(27.5)
            .background(Color.Style.grayDark)
            .ignoresSafeArea(.container, edges: .vertical)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    var content: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 150, idealHeight: 200, maxHeight: 200, alignment: .center)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                
                ForEach(formItems.indices, id: \.self) { index in
                    FormItemRow(item: self.$formItems[index])
                }
                
                Button(action: onCommitForgotPassword) {
                    Text("ESQUECI MINHA SENHA")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                
                FullWidthButton(titleKey: "CADASTRE-SE", action: onCommitSignUp)
                    .buttonStyle(.secondary(color: Color.Style.red))
                
                FullWidthButton(titleKey: "LOGIN", action: onCommitSignIn)
                    .buttonStyle(.primary(isDisabled: !signInEnabled))
                    .disabled(!signInEnabled)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(
                formItems: .constant(
                    [
                        FormItem(title: "CPF / CNPJ", keyboardType: UIKeyboardType.default, isSecure: false),
                        FormItem(title: "SENHA", keyboardType: UIKeyboardType.default, isSecure: true),
                    ]
                ),
                signInEnabled: .constant(true),
                loading: false,
                onCommitSignIn: { },
                onCommitSignUp:  { },
                onCommitForgotPassword: { }
            )
            .previewDevice("iPhone SE (2nd generation)")
            LoginView(
                formItems: .constant(
                    [
                        FormItem(title: "CPF / CNPJ", keyboardType: UIKeyboardType.default, isSecure: false),
                        FormItem(title: "SENHA", keyboardType: UIKeyboardType.default, isSecure: true),
                        FormItem(title: "SENHA", keyboardType: UIKeyboardType.default, isSecure: true, validateInText: { _ in ("CPF inválido", false) })
                    ]
                ),
                signInEnabled: .constant(false),
                loading: false,
                onCommitSignIn: { },
                onCommitSignUp:  { },
                onCommitForgotPassword: { }
            )
            .previewDevice("iPhone 11")
        }
    }
}
