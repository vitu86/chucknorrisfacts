//
//  DatabaseHelper.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RealmSwift
import Realm

class DatabaseHelper {
    
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DatabaseHelper = DatabaseHelper()
    
    // private init for override purpose
    private init() {
    }
    
    // MARK: - Category Functions
    func getCategories() -> [Category] {
        var categories:[Category] = []
        if let realm = try? Realm() {
            categories = realm.objects(Category.self).map{$0}
            categories.shuffle()
            categories = Array(categories.prefix(8))
        }
        return categories
    }
    
    func saveCategories(_ categories:[String]) -> [Category] {
        let realmCategories = categories.map({ (item) -> Category in
            return Category(item)
        })
        
        if let realm = try? Realm() {
            try! realm.write {
                for item in realmCategories {
                    realm.add(item, update: true)
                }
            }
        }
        
        return getCategories()
    }
    
    // MARK: - History Functions
    func getHistories() -> [History] {
        var histories:[History] = []
        if let realm = try? Realm() {
            histories = realm.objects(History.self).sorted(byKeyPath: "date", ascending: false).map{$0}
            histories = Array(histories.prefix(10))
        }
        return histories
    }
    
    func saveHistory(_ historyEntry:String) {
        if let realm = try? Realm() {
            try! realm.write {
                realm.add(History(historyEntry), update: true)
            }
        }
    }
    
    func deleteHistory(_ history:History)  -> [History] {
        if let realm = try? Realm() {
            try! realm.write {
                realm.delete(history)
            }
        }
        return getHistories()
    }
}
