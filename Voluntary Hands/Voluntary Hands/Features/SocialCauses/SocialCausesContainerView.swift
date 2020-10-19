//
//  SocialCausesContainerView.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 19/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

struct SocialCausesContainerView: View {
    @EnvironmentObject var store: Store<SocialCausesState, SocialCausesAction>
    
    var body: some View {
        SocialCausesView(
            loading: store.state.loading,
            causes: store.state.causes,
            causesSelected: store.state.causesSelected,
            onSelectCause: { store.send(.appendCauseSelected(cause: $0)) },
            onDeselectCause: { store.send(.removeCauseSelected(cause: $0)) },
            onCommit: { requestSaveCausesSelected() }
        )
        .onAppear {
            store.send(.resetState)
            requestFetchCauses()
        }
    }
}

// MARK: - Requets

extension SocialCausesContainerView {
    
    private func requestFetchCauses() {
        store.send(.fetchCauses)
    }
    
    private func requestSaveCausesSelected() {
        store.send(.saveCausesSelected)
    }
}

struct SocialCausesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SocialCausesContainerView()
    }
}
