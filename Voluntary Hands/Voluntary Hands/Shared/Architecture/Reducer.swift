//
//  Reducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

struct Reducer<State, Action, Environment> {
    
    // MARK: - Public properties
    let reduce: (inout State, Action, Environment) -> AnyPublisher<Action, Never>
}

// MARK: - Public methods
extension Reducer {
    
    func callAsFunction(
        _ state: inout State,
        _ action: Action,
        _ environment: Environment) -> AnyPublisher<Action, Never> {
        
        reduce(&state, action, environment)
    }

    func indexed<LiftedState, LiftedAction, LiftedEnvironment, Key>(
        keyPath: WritableKeyPath<LiftedState, [Key: State]>,
        extractAction: @escaping (LiftedAction) -> (Key, Action)?,
        embedAction: @escaping (Key, Action) -> LiftedAction,
        extractEnvironment: @escaping (LiftedEnvironment) -> Environment) -> Reducer<LiftedState, LiftedAction, LiftedEnvironment> {
        
        .init { state, action, environment in
            guard let (index, action) = extractAction(action) else {
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            let environment = extractEnvironment(environment)
            return self.optional()
                .reduce(&state[keyPath: keyPath][index], action, environment)
                .map { embedAction(index, $0) }
                .eraseToAnyPublisher()
        }
    }

    func indexed<LiftedState, LiftedAction, LiftedEnvironment>(
        keyPath: WritableKeyPath<LiftedState, [State]>,
        extractAction: @escaping (LiftedAction) -> (Int, Action)?,
        embedAction: @escaping (Int, Action) -> LiftedAction,
        extractEnvironment: @escaping (LiftedEnvironment) -> Environment) -> Reducer<LiftedState, LiftedAction, LiftedEnvironment> {
        
        .init { state, action, environment in
            guard let (index, action) = extractAction(action) else {
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            let environment = extractEnvironment(environment)
            return self.reduce(&state[keyPath: keyPath][index], action, environment)
                .map { embedAction(index, $0) }
                .eraseToAnyPublisher()
        }
    }

    func optional() -> Reducer<State?, Action, Environment> {
        .init { state, action, environment in
            if state != nil {
                return self(&state!, action, environment)
            } else {
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
        }
    }

    func lift<LiftedState, LiftedAction, LiftedEnvironment>(
        keyPath: WritableKeyPath<LiftedState, State>,
        extractAction: @escaping (LiftedAction) -> Action?,
        embedAction: @escaping (Action) -> LiftedAction,
        extractEnvironment: @escaping (LiftedEnvironment) -> Environment) -> Reducer<LiftedState, LiftedAction, LiftedEnvironment> {
        
        .init { state, action, environment in
            let environment = extractEnvironment(environment)
            guard let action = extractAction(action) else {
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            let effect = self(&state[keyPath: keyPath], action, environment)
            return effect.map(embedAction).eraseToAnyPublisher()
        }
    }

    static func combine(_ reducers: Reducer...) -> Reducer {
        .init { state, action, environment in
            let effects = reducers.compactMap { $0(&state, action, environment) }
            return Publishers.MergeMany(effects).eraseToAnyPublisher()
        }
    }
}
