//
//  Storage.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//

import Foundation
import UIKit
import CoreData

internal final class Storage {
    public typealias StorageCompletion = (Result<String, Error>) -> Void

    static var shared = Storage()
    private var databaseWorker = DatabaseWorker()
    internal var spendInfos: [SpendInfo] = []
    internal var trasactionDailyGroup = TransactionDailyGroup()
    
    private init() {}
    
    internal func deleteAllData() {
        databaseWorker.deleteAll(SpendInfo.self)
    }
    
    internal func fetchData(completion: @escaping ([SpendInfo]) -> Void) {
        self.spendInfos.removeAll()
        databaseWorker.read(SpendInfo.self)?.forEach({ [weak self] in
            self?.spendInfos.append($0)
        })
        
        spendInfos = spendInfos.sorted(by: { $0.date > $1.date })
        completion(spendInfos)
    }
}
