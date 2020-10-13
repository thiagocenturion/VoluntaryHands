//
//  RegisterDataView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

struct RegisterDataView: View {
    @Binding var image: UIImage?
    @Binding var userType: UserType
    
    @State private var signInEnabled = false
    
    @ObservedObject private var cpf = StringLimit(text: "", limit: "999.999.999-99".count)
    @State private var cpfError: String?
    
    @State private var email = ""
    @State private var emailError: String?
    
    @State private var firstName = ""
    @State private var firstNameError: String?
    
    @State private var lastName = ""
    @State private var lastNameError: String?
    
    @ObservedObject private var cellphone = StringLimit(text: "", limit: "(99) 99999-9999".count)
    @State private var cellphoneError: String?
    
    @State private var birthDate = Date()
    
    @State private var password = ""
    @State private var passwordError: String?
    
    @State private var confirmPassword = ""
    @State private var confirmPasswordError: String?
    
    let onCommitSignUpVolunteer: (RegisterVolunteer) -> Void
    
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
                    FloatingTextField(title: "CPF", text: $cpf.text, error: $cpfError, mask: { _ in "999.999.999-99" }, validate: { $0.validation(.cpf) })
                        .keyboardType(.numberPad)
                        .textContentType(.username)
                    
                    FloatingTextField(title: "E-MAIL", text: $email, error: $emailError, validate: { $0.validation(.email) })
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .background(Color.Style.grayMedium)
                .cornerRadius(15)
                .shadow(radius: 10)
                
                VStack {
                    FloatingTextField(title: "PRIMEIRO NOME", text: $firstName, error: $firstNameError, validate: { $0.validation(.empty) })
                        .textContentType(.name)
                        .disableAutocorrection(true)
                    
                    FloatingTextField(title: "SOBRENOME", text: $lastName, error: $lastNameError, validate: { $0.validation(.empty) })
                        .textContentType(.familyName)
                        .disableAutocorrection(true)
                    
                    FloatingTextField(title: "CELULAR", text: $cellphone.text, error: $cellphoneError, mask: { _ in "(99) 99999-9999" }, validate: { $0.validation(.cellphone) })
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                    
                    DatePicker("DATA DE NASCIMENTO", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    FloatingTextField(title: "SENHA", text: $password, error: $passwordError, isSecure: true, validate: { $0.validation(.newPassword) })
                        .textContentType(.newPassword)
                    
                    FloatingTextField(title: "CONFIRMAÇÃO DE SENHA", text: $confirmPassword, error: $confirmPasswordError, isSecure: true, validate: { $0.validation(.confirmPassword(newPassword: password)) })
                        .textContentType(.newPassword)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .background(Color.Style.grayMedium)
                .cornerRadius(15)
                .shadow(radius: 10)
                
                FullWidthButton(titleKey: "FINALIZAR CADASTRO", action: {
                    onCommitSignUpVolunteer(
                        RegisterVolunteer(
                            cpf: cpf.text,
                            email: email,
                            firstName: firstName,
                            lastName: lastName,
                            cellphone: cellphone.text,
                            birthdate: birthDate,
                            state: "SP",
                            city: "São Paulo",
                            password: password,
                            confirmPassword: confirmPassword
                        )   
                    )
                })
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
        .onReceive(Just([
            cpf.text.validation(.cpf),
            email.validation(.email),
            firstName.validation(.empty),
            lastName.validation(.empty),
            cellphone.text.validation(.cellphone),
            password.validation(.newPassword),
            confirmPassword.validation(.confirmPassword(newPassword: password))
        ])) { validates in
            signInEnabled = validates.map { $0.isValid }.reduce(&&)
        }
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterDataView(
                image: .constant(nil),
                userType: .constant(.volunteer),
                onCommitSignUpVolunteer: { _ in }
            )
            .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
