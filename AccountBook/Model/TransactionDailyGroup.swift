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
}
