//
//  Storage.swift
//  AccountBook
//
//  Created by PKH on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Storage {
    
    let modelName = "Transaction"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: modelName, in: context)

    static var shared = Storage()
    var transactions: [Transaction] = []
    var trasactionDailyGroup = TransactionDailyGroup(transactions: [], date: Date())
    
    init() {
        loadFromData()
    }
    
    mutating func deleteData() {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: modelName)
        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch {
            print("fail save")
        }
    }
    
    mutating func loadFromData() {
        // Json 파일에서 읽어오도록 해주세요. 아니면 코어데이터를 이용해주세요.
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
                
                transactions.append(Transaction(amount: amount, date: date, type: type, text: text))
            }
            print(transactions)
            transactions = transactions.sorted(by: { $0.date > $1.date })
            trasactionDailyGroup.transactions = transactions
        } catch {
            print("could not fetch")
        }
    }
    
    mutating func saveData(_ amount: Float, _ type: String, _ memo: String, completion: @escaping ((Bool)->Void)) {
        
        if let entity = entity {
            let transaction = NSManagedObject(entity: entity, insertInto: context)
            transaction.setValue(amount, forKey: "amount")
            transaction.setValue(Date(), forKey: "date")
            transaction.setValue("\(type.convert(type))", forKey: "type")
            transaction.setValue(memo, forKey: "text")

            do {
                try context.save()
                completion(true)
            } catch {
                print("\(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
