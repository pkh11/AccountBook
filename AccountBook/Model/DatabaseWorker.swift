//
//  DatabaseWorker.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/17
//
        

import Foundation
import RealmSwift

protocol DBAPI: AnyObject {
    func read<T: Object>(_ mode: T.Type) -> Results<T>?
    func write<T: Object>(_ model: T)
}

internal final class DatabaseWorker: DBAPI {
    
    private var realm: Realm?
    private var database: Realm {
        get throws {
            guard let realm = realm else { throw DatabaseError.fetchError }
            return realm
        }
    }

    internal init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Database Error")
        }
    }

    internal func read<T: Object>(_ model: T.Type) -> Results<T>? {
        do {
            return try database.objects(model)
        } catch {
            return nil
        }
    }

    internal func write<T: Object>(_ model: T) {
        do {
            try database.write({
                try database.add(model, update: .modified)
            })
        } catch let error {
            print(error)
        }
    }
}

enum DatabaseError: Error {
    case fetchError
}
