//
//  SocialCausesReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

let socialCausesReducer: Reducer<SocialCausesState, SocialCausesAction, SocialCausesServicesEnvironmentType> = Reducer { state, action, environment in
    
    switch action {
    case .causes(let response):
        state.causes = response.causes
        state.causesSelected = response.causesSelected
        
    case .appendCauseSelected(let cause):
        state.causesSelected.append(cause)
        
    case .removeCauseSelected(let cause):
        state.causesSelected.removeAll(where: { $0 == cause })
        
    case .multiSelection(let isMultiSelection):
        state.multiSelection = isMultiSelection
        
    case .fetchCauses:
        state.loading = .opaque
        
        return environment.socialCausesServices.fetchCauses()
            .map { SocialCausesAction.causes(response: $0) }
            .catch { error in Just<SocialCausesAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .saveCausesSelected:
        state.loading = .transparent
        
        return environment.socialCausesServices.save(causesSelected: state.causesSelected)
            .map { _ in SocialCausesAction.savingSuccess }
            .catch { error in Just<SocialCausesAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .savingSuccess:
        state.loading = .none
        state.savingSuccess = true
        
    case .alert(let error):
        state.loading = .none
        
        var alertError: AlertError?
        if let networkingError = error as? NetworkingError {
            switch networkingError {
            case .serverErrorMessage(let message):
                alertError = .init(title: "Puxa!", message: message ?? "Houve um problema. Tente novamente.")
            default:
                alertError = .init(title: "Oops!", message: "Houve um problema. Tente novamente.")
            }
        } else {
            alertError = error != nil ? .init(title: "Oops!", message: "Houve um problema. Tente novamente.") : nil
        }
        
        state.alert = alertError
        
    case .set(let newState):
        state = newState
        
    case .resetState:
        state.loading = .none
        state.causes = []
        state.causesSelected = []
        state.getCausesSuccess = false
        state.savingSuccess = false
        state.multiSelection = true
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
