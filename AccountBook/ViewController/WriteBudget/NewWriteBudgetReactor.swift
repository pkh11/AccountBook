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
        case inputAmount(String)
        case inputDate(String)
        case inputType(String)
        case inputMemo(String)
        case saveBtnTapped
    }
    
    enum Mutation {
        case inputAmount(String)
        case inputDate(String)
        case inputType(String)
        case inputMemo(String)
        case isValid
        case saveBtnTapped
    }
    
    struct State {
        var amount: String = ""
        var date: String = ""
        var type: String = ""
        var memo: String = ""
        var isCompleted: Bool?
        var isValid: Bool?
    }
    
    internal var initialState: State
    private var paramModel: SpendInfo = SpendInfo()
    private let dataBaseWorker: DatabaseWorker = DatabaseWorker()
    
    init() {
        self.initialState = State()
    }
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputAmount(let amount):
            return .concat([
                .just(.inputAmount(amount)),
                .just(.isValid)
            ])
            
        case .inputDate(let date):
            return .concat([
                .just(.inputDate(date)),
                .just(.isValid)
            ])
            
        case .inputType(let type):
            return .concat([
                .just(.inputType(type)),
                .just(.isValid)
            ])

        case .inputMemo(let memo):
            return .concat([
                .just(.inputMemo(memo)),
                .just(.isValid)
            ])
            
        case .saveBtnTapped:
            return .just(.saveBtnTapped)
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isCompleted = nil
        
        switch mutation {
        case .inputAmount(let amount):
            newState.amount = amount.convertToComma()
            
        case .inputDate(let date):
            newState.date = date
            
        case .inputType(let type):
            newState.type = type
            
        case .inputMemo(let memo):
            newState.memo = memo
            
        case .isValid:
            newState.isValid = !self.currentState.amount.isEmpty &&
                                !self.currentState.date.isEmpty &&
                                !self.currentState.type.isEmpty &&
                                !self.currentState.memo.isEmpty
            
        case .saveBtnTapped:
            paramModel = SpendInfo(self.currentState.amount,
                                   self.currentState.date,
                                   self.currentState.type,
                                   self.currentState.memo)
            dataBaseWorker.write(paramModel.self)
            newState.isCompleted = true

        }
        
        return newState
    }

}
