//
//  LoginViewModel.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var pushed = false
    
    private var disposables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    func loginButtonTapped() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.isLoading = false
        }
    }
    
    func signUpButtonTapped() {
        //
    }
}
