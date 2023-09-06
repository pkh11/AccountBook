//
//  HomeViewModel.swift
//  AccountBook
//
//  Created by 박균호 on 2021/01/12.
//  Copyright © 2021 FastCampus. All rights reserved.
//

import Foundation
import RxSwift

internal final class HomeViewModel {

    private var spendInfos: [SpendInfo] = [] {
        didSet {
            let used = self.spendInfos.map { $0.amount }.reduce(0) { $0 + $1 }
            self.reloadTableViewClosure?(used)
        }
    }

    private var storage = Storage.shared
    internal var reloadTableViewClosure: ((Float) -> ())?
    
    internal func isEffectiveLimit() -> Observable<String> {
        let type = storage.trasactionDailyGroup.mostUsedType
        return Observable.just(type)
    }
    
    internal func limitCheck() -> Observable<String> {
        let mostUsedType = storage.trasactionDailyGroup.mostUsedType
        var warningText = ""
        
        if !mostUsedType.isEmpty {
            warningText = "가장 많이 사용한 유형은 '\(mostUsedType)' 입니다."
        }
        return Observable.just(warningText)
    }
    
    internal func numberOfDatas() -> Int {
        return self.spendInfos.count
    }
    
    internal func getData(_ index: Int) -> SpendInfo {
        return self.spendInfos[index]
    }
    
    internal func fetchDatas() {
        storage.fetchData { [weak self] spendInfos in
            self?.spendInfos = spendInfos
        }
    }
    
    internal func getRemainCost() -> Int {
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int else {
            return 0
        }
        
        return myAccount - self.spendInfos.map{ $0.amountFloatToInt }.reduce(0, { $0 + $1})
    }
}
