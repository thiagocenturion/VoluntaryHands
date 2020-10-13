//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataView: View {
    @Binding var image: UIImage?
    @Binding var userType: UserType
    @Binding var volunteerHeaderForm: [FormItem]
    @Binding var volunteerBodyForm: [FormItem]
    @Binding var signInEnabled: Bool
    
    @State private var birthDate = Date()
    
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
                    ForEach(volunteerHeaderForm.indices, id: \.self) { index in
                        FormItemRow(item: self.$volunteerHeaderForm[index])
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .background(Color.Style.grayMedium)
                .cornerRadius(15)
                .shadow(radius: 10)
                
                VStack {
                    DatePicker("DATA DE NASCIMENTO", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    ForEach(volunteerBodyForm.indices, id: \.self) { index in
                        FormItemRow(item: self.$volunteerBodyForm[index])
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .background(Color.Style.grayMedium)
                .cornerRadius(15)
                .shadow(radius: 10)
                
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
                volunteerHeaderForm: .constant([
                    FormItem(title: "CPF", maskInText: { _ in "999.999.999-99" }, keyboardType: .numberPad, isSecure: false),
                    FormItem(title: "E-mail", keyboardType: .emailAddress, isSecure: false)
                ]), volunteerBodyForm: .constant([
                    FormItem(title: "PRIMEIRO NOME", keyboardType: .default, isSecure: false),
                    FormItem(title: "SOBRENOME", keyboardType: .default, isSecure: false),
                    FormItem(title: "CELULAR", keyboardType: .default, isSecure: false)
                ]),
                signInEnabled: .constant(true),
                onCommitSignUp: { }
            )
            .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
