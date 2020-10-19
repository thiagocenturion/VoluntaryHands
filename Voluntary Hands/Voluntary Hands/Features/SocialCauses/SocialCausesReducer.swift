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
    case .causes(let causes):
        state.loading = true
        
        return environment.socialCausesServices.causes()
            .map { _ in SocialCausesAction.getCausesSuccess }
            .catch { error in Just<SocialCausesAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .appendCauseSelected(let cause):
        state.causesSelected.append(cause)
        
    case .removeCauseSelected(let cause):
        state.causesSelected.removeAll(where: { $0 == cause })
        
    case .multiSelection(let isMultiSelection):
        state.multiSelection = isMultiSelection
        
    case .saveSocialCauses:
        state.loading = true
        
        return environment.socialCausesServices.save(causesSelected: state.causesSelected)
            .map { _ in SocialCausesAction.savingSuccess }
            .catch { error in Just<SocialCausesAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .getCausesSuccess:
        state.loading = false
        state.getCausesSuccess = true
        
    case .savingSuccess:
        state.loading = false
        state.savingSuccess = true
        
    case .alert(let error):
        state.loading = false
        
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
        state.loading = false
        state.causes = []
        state.causesSelected = []
        state.getCausesSuccess = false
        state.savingSuccess = false
        state.multiSelection = true
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
