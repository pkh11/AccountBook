//
//  Transaction.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//

import Foundation

struct Account {
    var amount: Float
    var date: Date
    var type: String
    var text: String
    
    var amountFloatToInt: Int {
        return Int(amount)
    }
}
