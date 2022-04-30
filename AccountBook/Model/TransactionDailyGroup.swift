//
//  TransactionDailyGroup.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//

import Foundation

struct TransactionDailyGroup {
    // Transaction들을 day기준으로 모아놓은 것입니다.
    var transactions: [Account] = Storage.shared.transactions
    var date: Date
    
    var total: Float {
        let totalSum = Storage.shared.transactions.map{ Int($0.amount) }.reduce(0){ $0 + $1 }
        return Float(totalSum)
    }
    
    var totalToInt: Int {
        return Int(total)
    }
    
    /// - TODO: 가장 많이 사용한 분류 출력
    var mostUsedType: String {
        let transactions = Storage.shared.transactions
        let total = Float(transactions.map{ Int($0.amount) }.reduce(0){ $0 + $1 })
        var map = [String : Float]()
        for transaction in transactions {
            if let amount = map[transaction.type] {
                map[transaction.type]  = amount + transaction.amount
            }
            map[transaction.type] = transaction.amount
        }
        
        guard let type = map.sorted(by: { $0.value > $1.value }).first else { return "" }
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Float else {
            return ""
        }
        
        let limit = myAccount * 0.8
        if total >= limit {
            print(type)
            return type.key
        }
        
        return ""
    }
}
