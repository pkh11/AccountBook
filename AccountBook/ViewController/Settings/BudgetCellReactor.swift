//
//  BudgetCellReactor.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/06/14.
//  Copyright © 2023 FastCampus. All rights reserved.
//

import ReactorKit
import RxSwift

internal final class BudgetCellReactor: Reactor {
    enum Action {
        case none
    }
    
    enum Mutation {
        case none
    }
    
    struct State {
        var model: Settings
    }
    
    internal var initialState: State
    
    init(model: Settings) {
        self.initialState = State(model: model)
    }
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .none: return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .none: break
                                                    
        }
        
        return newState
    }
}
