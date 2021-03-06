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
    var image: UIImage?
    @Binding var userType: UserType
    @Binding var termsAccepted: Bool
    var loading: Bool
    
    @State private var signInEnabled = false
    
    @StateObject private var volunteerCpf = StringLimit(text: "", limit: "999.999.999-99".count)
    @State private var volunteerCpfError: String?
    
    @StateObject private var institutionCnpj = StringLimit(text: "", limit: "99.999.999/9999-99".count)
    @State private var institutionCnpjError: String?
    
    @State private var email = ""
    @State private var emailError: String?
    
    @State private var volunteerFirstName = ""
    @State private var volunteerFirstNameError: String?
    
    @State private var institutionCompanyName = ""
    @State private var institutionCompanyNameError: String?
    
    @State private var volunteerLastName = ""
    @State private var volunteerLastNameError: String?
    
    @State private var institutionTradingName = ""
    @State private var institutionTradingNameError: String?
    
    @StateObject private var cellphone = StringLimit(text: "", limit: "(99) 99999-9999".count)
    @State private var cellphoneError: String?
    
    @State private var volunteerBirthDate = Date()
    
    @State private var selectedState = FederalStateType.none
    
    @State private var city = ""
    @State private var cityError: String?
    
    @State private var password = ""
    @State private var passwordError: String?
    
    @State private var confirmPassword = ""
    @State private var confirmPasswordError: String?
    
    @State private var institutionObjective = ""
    @State private var institutionObjectiveError: String?
    
    let onCommitSignUpVolunteer: (RegisterVolunteer) -> Void
    let onCommitSignUpInstitution: (RegisterInstitution) -> Void
    let onCommitProfileImage: () -> Void
    let onCommitPrivacyPolicy: () -> Void
    let onCommitUseTerms: () -> Void
    
    var body: some View {
        ZStack {
            if loading {
                content.opacity(0.3)
                    .allowsHitTesting(false)
                ActivityView()
            } else {
                content
            }
        }
    }
    
    var content: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Spacer(minLength: 64) // Navigation
            Spacer(minLength: 20)
            
            ProfileImage(image: image, isEditable: true, action: onCommitProfileImage)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                SegmentedPicker(data: UserType.allCases, id: \.self, selection: $userType) { type in
                    Text(LocalizedStringKey(type.rawValue)).tag(type)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                
                if userType == .volunteer {
                    volunteerContent
                        .onReceive(Just([
                            volunteerCpf.text.validation(.cpf),
                            email.validation(.email),
                            volunteerFirstName.validation(.empty),
                            volunteerLastName.validation(.empty),
                            cellphone.text.validation(.cellphone),
                            .init(errorMessage: nil, isValid: selectedState != .none),
                            city.validation(.empty),
                            password.validation(.newPassword),
                            confirmPassword.validation(.confirmPassword(newPassword: password))
                        ])) { validates in
                            signInEnabled = validates.map { $0.isValid }.reduce(&&) && termsAccepted
                        }
                } else {
                    institutionContent
                        .onReceive(Just([
                            institutionCnpj.text.validation(.cnpj),
                            email.validation(.email),
                            institutionCompanyName.validation(.empty),
                            institutionTradingName.validation(.empty),
                            cellphone.text.validation(.cellphone),
                            .init(errorMessage: nil, isValid: selectedState != .none),
                            city.validation(.empty),
                            password.validation(.newPassword),
                            confirmPassword.validation(.confirmPassword(newPassword: password)),
                            institutionObjective.validation(.empty)
                        ])) { validates in
                            signInEnabled = validates.map { $0.isValid }.reduce(&&) && termsAccepted
                        }
                }
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
    
    var institutionContent: some View {
        VStack(spacing: 20) {
            VStack {
                FloatingTextField(title: "CNPJ", text: $institutionCnpj.text, error: $institutionCnpjError, mask: { _ in "99.999.999/9999-99" }, validate: { $0.validation(.cnpj) })
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
            
            VStack(alignment: .leading) {
                FloatingTextField(title: "RAZÃO SOCIAL", text: $institutionCompanyName, error: $institutionCompanyNameError, validate: { $0.validation(.empty) })
                    .textContentType(.organizationName)
                    .disableAutocorrection(true)

                FloatingTextField(title: "NOME FANTASIA", text: $institutionTradingName, error: $institutionTradingNameError, validate: { $0.validation(.empty) })
                    .textContentType(.organizationName)
                    .disableAutocorrection(true)

                FloatingTextField(title: "CELULAR", text: $cellphone.text, error: $cellphoneError, mask: { _ in "(99) 99999-9999" }, validate: { $0.validation(.cellphone) })
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)

                federalState
                    .pickerStyle(MenuPickerStyle())
                    .textContentType(.addressState)

                FloatingTextField(title: "CIDADE", text: $city, error: $cityError, validate: { $0.validation(.empty) })
                    .textContentType(.addressCity)
                    .disableAutocorrection(true)

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
            
            VStack(alignment: .leading) {
                FloatingTextEditor(title: "OBJETIVO DA INSTITUIÇÃO", text: $institutionObjective, error: $institutionObjectiveError, validate: { $0.validation(.empty) })
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .background(Color.Style.grayMedium)
            .cornerRadius(15)
            .shadow(radius: 10)
            
            // Privacy Policy and Terms
            privacyPolicyContent
            
            FullWidthButton(titleKey: "FINALIZAR CADASTRO", action: {
                onCommitSignUpInstitution(
                    RegisterInstitution(
                        cnpj: institutionCnpj.text.onlyNumbers,
                        email: email,
                        companyName: institutionCompanyName,
                        tradingName: institutionTradingName,
                        cellphone: cellphone.text.onlyNumbers,
                        state: selectedState.rawValue,
                        city: city,
                        password: password,
                        confirmPassword: confirmPassword,
                        objectives: institutionObjective
                    )
                )
            })
            .buttonStyle(.primary(isDisabled: !signInEnabled))
            .disabled(!signInEnabled)
            .padding(.bottom, 10)
        }
    }
    
    var volunteerContent: some View {
        VStack(spacing: 20) {
            VStack {
                FloatingTextField(title: "CPF", text: $volunteerCpf.text, error: $volunteerCpfError, mask: { _ in "999.999.999-99" }, validate: { $0.validation(.cpf) })
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
            
            VStack(alignment: .leading) {
                FloatingTextField(title: "PRIMEIRO NOME", text: $volunteerFirstName, error: $volunteerFirstNameError, validate: { $0.validation(.empty) })
                    .textContentType(.name)
                    .disableAutocorrection(true)
                
                FloatingTextField(title: "SOBRENOME", text: $volunteerLastName, error: $volunteerLastNameError, validate: { $0.validation(.empty) })
                    .textContentType(.familyName)
                    .disableAutocorrection(true)
                
                FloatingTextField(title: "CELULAR", text: $cellphone.text, error: $cellphoneError, mask: { _ in "(99) 99999-9999" }, validate: { $0.validation(.cellphone) })
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                
                DatePicker(selection: $volunteerBirthDate, in: ...Date(), displayedComponents: .date) {
                    Text("NASCIMENTO")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color.Style.grayLight)
                        .offset(y: 8)
                }
                .environment(\.locale, Locale(identifier: "pt_BR"))
                .datePickerStyle(CompactDatePickerStyle())
                    
                Divider()
                    .frame(height: 2)
                    .background(Color.Style.grayLight)
                
                federalState
                    .pickerStyle(MenuPickerStyle())
                    .textContentType(.addressState)
                
                FloatingTextField(title: "CIDADE", text: $city, error: $cityError, validate: { $0.validation(.empty) })
                    .textContentType(.addressCity)
                    .disableAutocorrection(true)
                
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
            
            // Privacy Policy and Terms
            privacyPolicyContent
            
            FullWidthButton(titleKey: "FINALIZAR CADASTRO", action: {
                onCommitSignUpVolunteer(
                    RegisterVolunteer(
                        cpf: volunteerCpf.text.onlyNumbers,
                        email: email,
                        firstName: volunteerFirstName,
                        lastName: volunteerLastName,
                        cellphone: cellphone.text.onlyNumbers,
                        birthdate: volunteerBirthDate,
                        state: selectedState.rawValue,
                        city: city,
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
    
    var federalState: some View {
        Group {
            Text("ESTADO")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.Style.grayLight)
                .offset(y: 8)
            Picker(selection: $selectedState, label: Text(selectedState.rawValue)) {
                ForEach(FederalStateType.allCases, id: \.self) { state in
                    Text(LocalizedStringKey(state.rawValue)).tag(state)
                }
            }
            Divider()
                .frame(height: 2)
                .background(Color.Style.grayLight)
        }
    }
    
    var privacyPolicyContent: some View {
        HStack {
            Button(action: { withAnimation(.linear) { _termsAccepted.wrappedValue = !termsAccepted } }) {
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1.5))
                        .frame(width: 24, height: 24)
                        .foregroundColor(termsAccepted ? Color.clear : Color.Style.gray)
                        .overlay(
                            Circle()
                                .fill(termsAccepted ? Color.Style.blueFade : Color.clear)
                                .frame(width: 24, height: 24)
                        )
                    
                    if termsAccepted {
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 7)
                    }
                }
            }
            .padding(2)
            
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text("Li e concordo com os")
                    Button(action: onCommitUseTerms) { Text("Termos de uso") }
                }
                HStack(spacing: 0) {
                    Text(" e ")
                    Button(action: onCommitPrivacyPolicy) { Text("Políticas de Privacidade") }
                }
            }
        }
    }
}

struct RegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RegisterDataView(
                    image: UIImage(named: "pictureExample"),
                    userType: .constant(.volunteer),
                    termsAccepted: .constant(false),
                    loading: false,
                    onCommitSignUpVolunteer: { _ in },
                    onCommitSignUpInstitution: { _ in },
                    onCommitProfileImage: { },
                    onCommitPrivacyPolicy: { },
                    onCommitUseTerms: { }
                )
                .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
            }
            .previewDevice("iPhone 11")
            
            NavigationView {
                RegisterDataView(
                    image: UIImage(named: "pictureExample"),
                    userType: .constant(.institution),
                    termsAccepted: .constant(true),
                    loading: false,
                    onCommitSignUpVolunteer: { _ in },
                    onCommitSignUpInstitution: { _ in },
                    onCommitProfileImage: { },
                    onCommitPrivacyPolicy: { },
                    onCommitUseTerms: { }
                )
                .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
            }
            .previewDevice("iPhone 8")
        }
        .preferredColorScheme(.dark)
    }
}
