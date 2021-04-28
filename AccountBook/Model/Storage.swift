//
//  Storage.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Storage {
    
    public typealias StorageCompletion = (Result<String, Error>) -> Void
    
    let modelName = "Transaction"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: modelName, in: context)

    static var shared = Storage()
    var transactions: [Account] = []
    var trasactionDailyGroup = TransactionDailyGroup(transactions: [], date: Date())
    
    init() {
        loadFromData(completion: { [weak self] data in
            guard let strongSelf = self else { return }
            
            strongSelf.transactions = data
        })
    }
    
    func deleteData() {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: modelName)
        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
        }
        
        transactions = []
        
        do {
            transactions = []
            try context.save()
        } catch {
            print("fail save")
        }
    }
    
    func loadFromData(completion: @escaping (([Account])->Void)) {
        
        transactions = []
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: modelName)
        do {
            let transaction =  try context.fetch(fetchRequest)
            transaction.forEach {
                
                guard let amount = $0.value(forKey: "amount") as? Float,
                      let date = $0.value(forKey: "date") as? Date,
                      let type = $0.value(forKey: "type") as? String,
                      let text = $0.value(forKey: "text") as? String else {
                    return
                }
                
                transactions.append(Account(amount: amount, date: date, type: type, text: text))
            }
            
            transactions = transactions.sorted(by: { $0.date > $1.date })
            
            completion(transactions)
        } catch {
            print("could not fetch")
            completion([])
        }
    }
    
    func saveData(_ amount: Float, _ date: Date, _ type: String, _ memo: String, completion: @escaping StorageCompletion) {
        
        let money = trasactionDailyGroup.totalToInt
        let expenditureMoney = Int(amount)
        
        if let account = UserDefaults.standard.value(forKey: "myAccount") as? Int {
            if account - money < expenditureMoney {
                completion(.failure(StorageErrors.overAccount))
                return
            }
        }
        
        if let entity = entity {
            let transaction = NSManagedObject(entity: entity, insertInto: context)
            transaction.setValue(amount, forKey: "amount")
            transaction.setValue(date, forKey: "date")
            transaction.setValue(type.convert(type), forKey: "type")
            transaction.setValue(memo, forKey: "text")

            do {
                try context.save()
                loadFromData(completion: { success in print("\(success)") })
                completion(.success("Success"))
            } catch {
                print("\(error.localizedDescription)")
                completion(.failure(StorageErrors.failedSaveData))
            }
        }
    }
}

enum StorageErrors: Error {
    case failedSaveData
    case overAccount
}
