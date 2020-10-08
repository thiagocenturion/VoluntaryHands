//
//  RegisterCoordinator.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RegisterCoordinator: View {
    var body: some View {
        RegisterDataContainerView()
            .navigationBarTitle("DADOS PESSOAIS", displayMode: .inline)
    }
}

struct RegisterCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCoordinator()
    }
}
