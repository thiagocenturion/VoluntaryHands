//
//  LoginView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 03/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: LoginViewModel
    
    @State var selection: Int? = nil

    // MARK: - View
    var body: some View {
        NavigationView {
            ZStack {
                if $viewModel.isLoading.wrappedValue {
                    GeometryReader { geometry in
                        LoadingView()
                    }
                }
                
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 215)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 15) {
                        TextFieldFloating("E-MAIL", text: $viewModel.username)
                        TextFieldFloating("SENHA", text: $viewModel.password, isSecure: true)
                        Button(action: { }) {
                            Text("ESQUECI MINHA SENHA")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        
                        NavigationLink(destination: RegisterDataView(viewModel: RegisterDataViewModel()), isActive: $viewModel.pushed) {

                            Button(action: { self.viewModel.pushed = true }) {
                                HStack {
                                    Spacer()
                                    Text("CADASTRE-SE")
                                    Spacer()
                                }
                            }
                            .buttonStyle(SecondaryBackgroundStyle(color: ColorStyle.red))
                        }
                        
                        Button(action: { self.viewModel.loginButtonTapped() }) {
                            HStack {
                                Spacer()
                                Text("LOGIN")
                                Spacer()
                            }
                        }
                        .buttonStyle(PrimaryBackgroundStyle())
                    }
                    
                }
            }
            .padding(27.5)
            .background(ColorStyle.grayDark)
            .edgesIgnoringSafeArea(.top)
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
