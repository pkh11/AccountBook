//
//  SpendInfo.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/08/28
//
        

import Foundation
import RealmSwift

internal final class SpendInfo: Object {
    @Persisted var amount: Float
    @Persisted var date: Date
    @Persisted var type: String
    @Persisted var text: String
    
    var amountFloatToInt: Int {
        return Int(amount)
    }
}
