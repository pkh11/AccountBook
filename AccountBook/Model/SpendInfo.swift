//
//  SpendInfo.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/08/28
//
        

import Foundation
import RealmSwift

internal final class SpendInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var amount: Float
    @Persisted var date: Date
    @Persisted var type: String
    @Persisted var text: String
    
    var amountFloatToInt: Int {
        return Int(amount)
    }
    
    convenience init(_ amount: Float, _ date: Date, _ type: String, _ text: String) {
        self.init()
        self.amount = amount
        self.date = date
        self.type = type
        self.text = text
    }
}
