//
//  TransactionDailyGroup.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

struct TransactionDailyGroup {
    // Transaction들을 day기준으로 모아놓은 것입니다.
    var transactions: [Account]
    var date: Date
    
    var total: Float {
        let totalSum = Storage.shared.transactions.map{ Int($0.amount) }.reduce(0){ $0 + $1 }
        return Float(totalSum)
    }
    
    var totalToInt: Int {
        return Int(total)
    }
    
    /// - TODO: 가장 많이 사용한 분류 출력
    var mostUsedType: Int {
        let transactions = Storage.shared.transactions
        var map = [String : Float]()
        for transaction in transactions {
            if let amount = map[transaction.type] {
                map[transaction.type]  = amount + transaction.amount
            }
            map[transaction.type] = transaction.amount
        }
        
        guard let type = map.sorted(by: { $0.value > $1.value }).map{ Int($0.key) }.first else { return 0 }
        // type
        
        return 0
        
    }
}
