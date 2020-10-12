//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
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
            mask: item.mask,
            isSecure: item.isSecure,
            onCommit: { }
        )
        .keyboardType(UIKeyboardType(rawValue: item.keyboardType) ?? .default)
            
    }
}

struct RegisterDataView: View {
    @Binding var image: UIImage?
    @Binding var userType: UserType
    @Binding var volunteerForm: [FormItem]
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

                VStack {
                    ForEach(volunteerForm.indices, id: \.self) { index in
                        FormItemRow(item: self.$volunteerForm[index])
                    }
                }
                
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
                image: .constant(nil),
                userType: .constant(.volunteer),
                volunteerForm: .constant([
                    FormItem(title: "CPF", mask: "999.999.999-99", keyboardType: UIKeyboardType.numberPad.rawValue, isSecure: false)
                ]),
                signInEnabled: .constant(true),
                onCommitSignUp: { }
            )
            .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
