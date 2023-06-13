//
//  NewSettingsReactor.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/13.
//  Copyright © 2023 FastCampus. All rights reserved.
//
import ReactorKit

internal final class NewSettingsReactor: Reactor {
    enum Action {
        case none
    }
    
    enum Mutation {
        case none
    }
    
    struct State {
        var test: Bool?
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
        newState.test = nil
        
        switch mutation {
        case .none: break
                                                    
        }
        
        return newState
    }

}