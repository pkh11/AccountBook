//
//  TransactionDailyGroup.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//

import Foundation

// TODO: 리팩토링
internal struct TransactionDailyGroup {
    private var total: Float {
        let totalSum = Storage.shared.spendInfos.map{ Int($0.amount) }.reduce(0){ $0 + $1 }
        return Float(totalSum)
    }
    
    internal var totalToInt: Int {
        return Int(total)
    }
    
    internal var mostUsedType: String {
        let spendInfos = Storage.shared.spendInfos
        let total = Float(spendInfos.map{ Int($0.amount) }.reduce(0){ $0 + $1 })
        var map = [String : Float]()
        for spendInfo in spendInfos {
            if let amount = map[spendInfo.type] {
                map[spendInfo.type]  = amount + spendInfo.amount
            }
            map[spendInfo.type] = spendInfo.amount
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
