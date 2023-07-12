//
//  HomeViewModel.swift
//  AccountBook
//
//  Created by 박균호 on 2021/01/12.
//  Copyright © 2021 FastCampus. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    private var datas: [Account] = [] {
        didSet {
            let used = self.datas.map{ $0.amount }.reduce(0) { $0 + $1 }
            self.reloadTableViewClosure?(used)
        }
    }
    private var storage = Storage.shared
    var reloadTableViewClosure: ((Float) -> ())?
    
    func isEffectiveLimit() -> Observable<String> {
        let type = storage.trasactionDailyGroup.mostUsedType
        return Observable.just(type)
    }
    
    func limitCheck() -> Observable<String> {
        let mostUsedType = storage.trasactionDailyGroup.mostUsedType
        var warningText = ""
        
        if !mostUsedType.isEmpty {
            warningText = "가장 많이 사용한 유형은 '\(mostUsedType)' 입니다."
        }
        return Observable.just(warningText)
    }
    
    func numberOfDatas() -> Int {
        return self.datas.count
    }
    
    func getData(_ index: Int) -> Account {
        return self.datas[index]
    }
    
    func fetchDatas() {
        storage.loadFromData(completion: { [weak self] data in
            self?.datas = data
        })
    }
    
    func getRemainCost() -> Int {
        guard let myAccount = UserDefaults.standard.value(forKey: "myAccount") as? Int else {
            return 0
        }
        
        return myAccount - self.datas.map{ Int($0.amount) }.reduce(0, { $0 + $1})
    }
}
