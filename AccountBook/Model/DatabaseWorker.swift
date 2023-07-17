//
//  DatabaseWorker.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/17
//
        

import Foundation
import RealmSwift

protocol DBAPI: AnyObject {
    func read()
    func write()
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

    func read() {
        
    }

    func write() {

    }
}

enum DatabaseError: Error {
    case fetchError
}
