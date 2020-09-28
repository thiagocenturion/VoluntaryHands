//
//  RootView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            LoginCoordinatorView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
