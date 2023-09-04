//
//  NewWriteBudgetReactor.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/09/04
//
        

import Foundation

import ReactorKit

internal final class NewWriteBudgetReactor: Reactor {
    enum Action {
        case none
    }
    
    enum Mutation {
        case none
    }
    
    struct State {
        var empty: Bool?
    }
    
    internal var initialState: State
    
    init() {
        self.initialState = State()
    }
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .none: return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .none:
            newState.empty = false
                                                    
        }
        
        return newState
    }

}
