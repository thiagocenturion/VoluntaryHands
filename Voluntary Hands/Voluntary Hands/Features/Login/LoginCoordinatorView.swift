//
//  LoginCoordinatorView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct LoginCoordinatorView: View {
    var body: some View {
        NavigationLink(
            destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
            tag: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/,
            selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            LoginView()
        }
    }
}

struct LoginCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        LoginCoordinatorView()
    }
}
