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
        case setAmount(String)
        case setDate(String)
        case setType(String)
        case setMemo(String)
        case saveBtnTapped
    }
    
    enum Mutation {
        case setAmount(String)
        case setDate(String)
        case setType(String)
        case setMemo(String)
        case setLoading(Bool)
        case isValid
        case saveBtnTapped
    }
    
    struct State {
        var amount: String = ""
        var date: String = ""
        var type: String = ""
        var memo: String = ""
        var accountResult: AccountResult?
        var isCompleted: Bool?
        var isValid: Bool?
        var isLoading: Bool?
    }
    
    internal var initialState: State
    private var paramModel: SpendInfo = SpendInfo()
    private let dataBaseWorker: DatabaseWorker = DatabaseWorker()
    
    static let amountLimit: Int = 7
    static let memoLimit: Int = 10
    
    init() {
        self.initialState = State()
    }
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setAmount(let amount):
            return .concat([
                .just(.setAmount(amount)),
                .just(.isValid)
            ])
            
        case .setDate(let date):
            return .concat([
                .just(.setDate(date)),
                .just(.isValid)
            ])
            
        case .setType(let type):
            return .concat([
                .just(.setType(type)),
                .just(.isValid)
            ])

        case .setMemo(let memo):
            return .concat([
                .just(.setMemo(memo)),
                .just(.isValid)
            ])
            
        case .saveBtnTapped:
            return .concat([
                .just(.setLoading(true)),
                .just(.saveBtnTapped).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                .just(.setLoading(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isCompleted = nil
        newState.isLoading = nil
        newState.isValid = nil
        newState.accountResult = nil
        
        switch mutation {
        case .setAmount(let amount):
            newState.amount = amount.convertToComma()
            newState.accountResult = checkMyAccount(amount)
            
        case .setDate(let date):
            newState.date = date
            
        case .setType(let type):
            newState.type = type
            
        case .setMemo(let memo):
            newState.memo = memo
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .isValid:
            newState.isValid = !self.currentState.amount.isEmpty &&
            self.currentState.amount.count <= NewWriteBudgetReactor.amountLimit &&
            !self.currentState.date.isEmpty &&
            !self.currentState.type.isEmpty &&
            !self.currentState.memo.isEmpty &&
            self.currentState.memo.count <= NewWriteBudgetReactor.memoLimit
            
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
    
    private func checkMyAccount(_ amount: String) -> AccountResult {
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int, myAccount != 0 else {
            return AccountResult.failure(AccountError.accountNotSet)
        }
        
        let totalAmount = dataBaseWorker.read(SpendInfo.self)?
            .map({ $0.amountFloatToInt })
            .reduce(0) { $0 + $1 } ?? 0

        if myAccount - totalAmount < amount.replacingOccurrences(of: ",", with: "").toInt() {
            return AccountResult.failure(AccountError.overAccount)
        }
        
        return AccountResult.success
    }
}

enum AccountResult {
    case success
    case failure(AccountError)
}

enum AccountError: Error {
    case overAccount
    case accountNotSet
    
    var message: String {
        switch self {
        case .overAccount: return "예산을 초과했습니다.😀"
        case .accountNotSet: return "예산을 설정해주세요.😀"
        }
    }
}
