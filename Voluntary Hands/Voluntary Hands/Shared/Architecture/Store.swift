//
//  Store.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 28/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Store<State, Action>: ObservableObject {
    
    // MARK: - Public properties
    @Published private(set) var state: State
    
    private let reduce: (inout State, Action) -> AnyPublisher<Action, Never>
    private let queue: DispatchQueue
    
    private var effectCancellables: [UUID: AnyCancellable] = [:]
    
    // MARK: - Initialization
    init<Environment>(
        initialState: State,
        reducer: Reducer<State, Action, Environment>,
        environment: Environment,
        subscriptionQueue: DispatchQueue = .init(label: "com.aaplab.store")) {
        
        self.state = initialState
        self.reduce = { state, action in reducer(&state, action, environment) }
        self.queue = subscriptionQueue
    }
}

// MARK: - Public properties
extension Store {
    
    func send(_ action: Action) {
        let effect = reduce(&state, action)

        var didComplete = false
        let uuid = UUID()

        let cancellable = effect
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    didComplete = true
                    self?.effectCancellables[uuid] = nil
                },
                receiveValue: { [weak self] in self?.send($0) }
            )

        if !didComplete {
            effectCancellables[uuid] = cancellable
        }
    }
    
    func derived<DerivedState: Equatable, ExtractedAction>(
        deriveState: @escaping (State) -> DerivedState,
        embedAction: @escaping (ExtractedAction) -> Action) -> Store<DerivedState, ExtractedAction> {
        
        let store = Store<DerivedState, ExtractedAction>(
            initialState: deriveState(state),
            reducer: Reducer { _, action, _ in
                self.send(embedAction(action))
                return Empty().eraseToAnyPublisher()
            },
            environment: ()
        )

        $state
            .map(deriveState)
            .removeDuplicates()
            .assign(to: &store.$state)

        return store
    }
    
    func binding<Value>(
        for keyPath: KeyPath<State, Value>,
        toAction: @escaping (Value) -> Action) -> Binding<Value> {
        
        Binding<Value>(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(toAction($0)) }
        )
    }
}

typealias AppStore = Store<AppState, AppAction>
