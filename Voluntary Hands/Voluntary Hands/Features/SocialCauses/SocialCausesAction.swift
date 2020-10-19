//
//  SocialCausesAction.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

enum SocialCausesAction {
    case causes(response: CausesResponse)
    case appendCauseSelected(cause: Cause)
    case removeCauseSelected(cause: Cause)
    case multiSelection(isMultiSelection: Bool)
    case fetchCauses
    case saveCausesSelected
    case savingSuccess
    case alert(error: Error?)
    case set(state: SocialCausesState)
    case resetState
}
