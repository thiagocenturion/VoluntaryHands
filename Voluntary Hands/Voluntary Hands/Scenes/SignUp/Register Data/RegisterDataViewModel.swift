//
//  RegisterDataViewModel.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI
import Combine

class RegisterDataViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var email = ""
    @Published var emailConfirm = ""
    @Published var password = ""
    @Published var passwordConfirm = ""
       
       private var disposables: Set<AnyCancellable> = []
}
