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
    var transactions: [Transaction]
    var date: Date
    
    var total: Float {
        // TODO: total이 그룹화된거에서 보여질거에요, 총 사용 금액
        let totalSum = Storage.shared.transactions.map{ Int($0.amount) }.reduce(0){ $0 + $1 }
        return Float(totalSum)
    }
    
    var totalToInt: Int {
        return Int(total)
    }
}
