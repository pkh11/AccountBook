//
//  ActionViewModel.swift
//  AccountBook
//
//  Created by 박균호 on 2020/11/30.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ActionViewModel {
    
    let amountLimit = 7
    let memoLimit = 10
    
    var storage = Storage.shared
    
    var account = BehaviorRelay(value: "")
    var date = BehaviorRelay(value: "")
    var type = BehaviorRelay(value: "")
    var memo = BehaviorRelay(value: "")
    
    func isValidate() -> Observable<Bool> {
        return Observable
            .combineLatest(account, memo, date, type)
            .map{ $0.0.replacingOccurrences(of: ",", with: "").count < self.amountLimit
                && !$0.0.isEmpty
                && $0.1.count < self.memoLimit
                && !$0.1.isEmpty
                && !$0.2.isEmpty
                && !$0.3.isEmpty}
    }
    
    func checkMyAccount() -> Bool {
        guard UserDefaults.standard.value(forKey: "myAccount") != nil else {
            return false
        }
        return true
    }
    
    func saveData() -> Bool {
        var result = false

        let accountToReplacing = account.value.replacingOccurrences(of: ",", with: "")
        guard let amount = Float(accountToReplacing) else {
            return result
        }
        let memoValue = memo.value
        let typeValue = type.value
        let dateValue = date.value
    
        storage.saveData(amount, dateValue.toDate(dateValue), typeValue, memoValue, completion: { success in
            result = success
        })
        return result
    }
}
