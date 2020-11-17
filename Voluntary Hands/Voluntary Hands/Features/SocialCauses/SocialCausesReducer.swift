//
//  SocialCausesReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 18/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import UIKit
import Combine

let socialCausesReducer: Reducer<SocialCausesState, SocialCausesAction, SocialCausesServicesEnvironmentType> = Reducer { state, action, environment in
    
    switch action {
    case .causes(let response):
        state.causes = response.causes
        state.causesSelected = response.causesSelected
        
    case .appendCauseSelected(let cause):
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        state.causesSelected.append(cause)
        
    case .removeCauseSelected(let cause):
        UINotificationFeedbackGenerator().notificationOccurred(.success)
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
        
//        return environment.socialCausesServices.save(causesSelected: state.causesSelected)
//            .map { _ in SocialCausesAction.savingSuccess }
//            .catch { error in Just<SocialCausesAction>(.alert(error: error)) }
//            .eraseToAnyPublisher()
        return Just<SocialCausesAction>(.savingSuccess).eraseToAnyPublisher()
        
    case .savingSuccess:
        state.loading = .none
        state.savingSuccess = true
        
    case .alert(let error):
        state.loading = .none
        
        guard let error = error else {
            state.alert = nil
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        var alertError: AlertError?
        if let networkingError = error as? NetworkingError {
            switch networkingError {
            case .serverErrorMessage(let message):
                alertError = .init(title: "Puxa!", message: message ?? "Houve um problema. Tente novamente.")
            case .invalidDecode:
                #warning("Thiago Centurion: MOCK! REMOVER!")
                return Just(SocialCausesAction.causes(response: CausesResponse(
                                                        causes: [
                                                            Cause(id: 0, cause: "MEIO AMBIENTE", iconUrl: ""),
                                                            Cause(id: 1, cause: "ANIMAIS", iconUrl: ""),
                                                            Cause(id: 2, cause: "CRIANÇAS", iconUrl: ""),
                                                            Cause(id: 3, cause: "IDOSOS", iconUrl: ""),
                                                            Cause(id: 4, cause: "EDUCAÇÃO", iconUrl: ""),
                                                            Cause(id: 5, cause: "SAÚDE", iconUrl: ""),
                                                            Cause(id: 6, cause: "MORADIA", iconUrl: ""),
                                                            Cause(id: 7, cause: "ASSISTÊNCIA SOCIAL", iconUrl: ""),
                                                            Cause(id: 8, cause: "OUTROS", iconUrl: "")
                                                        ],
                                                        causesSelected: []))).eraseToAnyPublisher()
            default:
                alertError = .init(title: "Oops!", message: "Houve um problema. Tente novamente.")
            }
        } else {
            alertError = .init(title: "Oops!", message: "Houve um problema. Tente novamente.")
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
