//
//  DatabaseHelper.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RealmSwift
import Realm
import RxRealm
import RxCocoa
import RxSwift

class DatabaseHelper {
    
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DatabaseHelper = DatabaseHelper()
    
    // MARK: - Private constants
    private let disposeBag:DisposeBag = DisposeBag()
    
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
    
    func saveCategories(_ categories:[String]) -> [Category]{
        let realmCategories = categories.map({ (item) -> Category in
            return Category(item)
        })
        
        Observable.from(optional: realmCategories)
            .subscribe(Realm.rx.add()).disposed(by: disposeBag)
        
        return getCategories()
    }
    
    // MARK: - History Functions
    func getHistories() -> Results<History>{
        let realm = try! Realm()
        let hists = realm.objects(History.self).sorted(byKeyPath: "date", ascending: false)
        return hists
    }
    
    func saveHistory(_ historyEntry:String) {
        Observable.from(optional: [History(historyEntry)])
            .subscribe(Realm.rx.add(configuration: .defaultConfiguration, update: true, onError: { (O, error) in
                print(error.localizedDescription)
            }) ).disposed(by: disposeBag)
    }
    
    func deleteHistory(_ history:History){
        Observable.from([history])
            .subscribe(Realm.rx.delete()).disposed(by: disposeBag)
    }
}
