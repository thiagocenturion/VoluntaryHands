//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataView: View {
    @Binding var volunteerForm: [FormItem]
    @Binding var image: UIImage?
    @Binding var userType: UserType
    @Binding var signInEnabled: Bool
    
    let onCommitSignUp: () -> Void
    
    @State private var showingImagePicker = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 64) // Navigation
            Spacer(minLength: 20)
            
            ProfileImage(image: $image, isEditable: true, action: { showingImagePicker = true })
                .sheet(isPresented: $showingImagePicker) { ImagePicker(image: self.$image) }
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                SegmentedPicker(data: UserType.allCases, id: \.self, selection: $userType) { type in
                    Text(LocalizedStringKey(type.rawValue)).tag(type)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .pickerStyle(SegmentedPickerStyle())
                
                FullWidthButton(titleKey: "FINALIZAR CADASTRO", action: onCommitSignUp)
                    .buttonStyle(.primary(isDisabled: !signInEnabled))
                    .disabled(!signInEnabled)
                    .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(27.5)
        .background(Color.Style.grayDark)
        .ignoresSafeArea(.container, edges: .vertical)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterDataView(
                volunteerForm: .constant([
                    FormItem(title: "CPF", mask: "999.999.999-99", keyboardType: UIKeyboardType.numberPad.rawValue, isSecure: false),
                    FormItem(title: "E-mail", mask: "", keyboardType: UIKeyboardType.emailAddress.rawValue, isSecure: false),
                    FormItem(title: "Nome completo", mask: "", keyboardType: UIKeyboardType.default.rawValue, isSecure: false),
                    FormItem(title: "Senha", mask: "", keyboardType: UIKeyboardType.webSearch.rawValue, isSecure: true)
                ]),
                image: .constant(nil),
                userType: .constant(.volunteer),
                signInEnabled: .constant(true),
                onCommitSignUp: { }
            )
            .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
