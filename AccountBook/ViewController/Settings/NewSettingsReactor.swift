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
        case loadSettingsItems
    }
    
    enum Mutation {
        case loadSettingsItems
    }
    
    struct State {
        var sections = [SettingsSectionModel]()
    }
    
    internal var initialState: State
    
    init() {
        self.initialState = State()
    }
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadSettingsItems:
            return .just(.loadSettingsItems)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadSettingsItems:
            var items = [SettingsItem]()
            
            for item in Settings.allCases {
                switch item {
                case .limit:
                    let reactor = BudgetCellReactor(model: item)
                    items.append(.budget(reactor: reactor))
                    
                case .appVersion:
                    let reactor = VersionInfoCellReactor(model: item)
                    items.append(.versionInfo(reactor: reactor))
                }
            }

            newState.sections = [.settings(items: items)]
                                                    
        }
        
        return newState
    }

}
