//
//  Storage.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
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
    
    init() {
        loadFromData()
    }
    
    mutating func deleteData() {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: modelName)
        do {
            if let results = try? context.fetch(fetchRequest) {
                for object in results {
                    context.delete(object)
                }
            }
        }
    }
    
    mutating func loadFromData() {
        // Json 파일에서 읽어오도록 해주세요. 아니면 코어데이터를 이용해주세요.
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: modelName)
        do {
            let transaction =  try context.fetch(fetchRequest)
            transaction.forEach {
                
                // TODO: Casting
                let amount = $0.value(forKey: "amount") as! Float
                let date = $0.value(forKey: "date") as! Date
                let type = $0.value(forKey: "type") as! String
                let text = $0.value(forKey: "text") as! String
                
                transactions.append(Transaction(amount: amount, date: date, type: type, text: text))
            }
        } catch {
            print("could not fetch")
        }
    }
    
    mutating func saveData() {
        
        if let entity = entity {
            let transaction = NSManagedObject(entity: entity, insertInto: context)
            transaction.setValue(15000, forKey: "amount")
            transaction.setValue(Date(), forKey: "date")
            transaction.setValue("\(SpendType.기타)", forKey: "type")
            transaction.setValue("기타 비용", forKey: "text")

            do {
                try context.save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
}
