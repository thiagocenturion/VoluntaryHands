//
//  SocialCausesContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 19/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SocialCausesContainerView: View {
    @Environment var store: Store<SocialCausesState, SocialCausesAction>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SocialCausesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SocialCausesContainerView()
    }
}
