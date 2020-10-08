//
//  RegisterDataContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterDataContainerView: View {
    @EnvironmentObject var store: Store<RegisterState, RegisterAction>
    
    @State private var signUpEnabled = false
    
    private var alertShow: Binding<AlertError?> {
        store.binding(for: \.alert) { _ in .alert(error: nil) }
    }
    
    @State private var volunteerCpfErrorMessage: String?
    @State private var volunteerEmailErrorMessage: String?
    @State private var volunteerFirstNameErrorMessage: String?
    @State private var volunteerLastNameErrorMessage: String?
    @State private var volunteerCellphoneErrorMessage: String?
    @State private var volunteerBirthdateErrorMessage: String?
    @State private var volunteerStateErrorMessage: String?
    @State private var volunteerCityErrorMessage: String?
    @State private var volunteerPasswordErrorMessage: String?
    @State private var volunteerConfirmPasswordErrorMessage: String?
    
    private var volunteerCPF: Binding<String> { store.binding(for: \.volunteer.cpf) { .volunteer(cpf: $0) } }
    private var volunteerEmail: Binding<String> { store.binding(for: \.volunteer.email) { .volunteer(email: $0) } }
    private var volunteerFirstName: Binding<String> { store.binding(for: \.volunteer.firstName) { .volunteer(firstName: $0) } }
    private var volunteerLastName: Binding<String> { store.binding(for: \.volunteer.lastName) { .volunteer(lastName: $0) } }
    private var volunteerCellphone: Binding<String> { store.binding(for: \.volunteer.cellphone) { .volunteer(cellphone: $0) } }
    private var volunteerBirthdate: Binding<Date?> { store.binding(for: \.volunteer.birthdate) { .volunteer(birthdate: $0) } }
    private var volunteerState: Binding<String> { store.binding(for: \.volunteer.state) { .volunteer(federalState: $0) } }
    private var volunteerCity: Binding<String> { store.binding(for: \.volunteer.city) { .volunteer(city: $0) } }
    private var volunteerPassword: Binding<String> { store.binding(for: \.volunteer.password) { .volunteer(password: $0) } }
    private var volunteerConfirmPassword: Binding<String> { store.binding(for: \.volunteer.confirmPassword) { .volunteer(confirmPassword: $0) } }
    
    var body: some View {
        
        let image = Binding<UIImage?>(
            get: {
                if let data = store.state.currentImage {
                    return UIImage(data: data)
                } else {
                    return nil
                }
            },
            set: { image in store.send(.currentImage(data: image?.jpegData(compressionQuality: 0.3))) }
        )
        
        RegisterDataView(image: image)
    }
}

struct RegisterDataContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterDataContainerView()
    }
}
