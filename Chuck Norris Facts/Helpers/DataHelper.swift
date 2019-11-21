//
//  DataHelper.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

class DataHelper {
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DataHelper = DataHelper()
    
    // MARK: - Public Properties
    var categories:BehaviorRelay<[Category]> = BehaviorRelay<[Category]>(value: [])
    var histories:BehaviorRelay<[History]> = BehaviorRelay<[History]>(value: [])
    
    // MARK: - Private Properties
    private let disposeBag:DisposeBag = DisposeBag()
    
    // private init for override purpose
    private init() {
        bindHistories()
        initSuggestions()
    }
    
    // MARK: Private Functions
    private func bindHistories() {
        DatabaseHelper.shared.bindHistories(with: histories, and: disposeBag)
    }
    
    private func initSuggestions() {
        categories.accept(DatabaseHelper.shared.getCategories())
        if categories.value.count <= 0 {
            updateCategories()
        }
    }
    
    private func updateCategories() {
        NetworkHelper.shared.getCategories { (cats) in
            let categories = DatabaseHelper.shared.saveCategories(cats)
            self.categories.accept(categories)
        }
    }
    
    // MARK: Public Functions
    func shuffleSuggestions() {
        categories.accept(DatabaseHelper.shared.getCategories())
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        DatabaseHelper.shared.deleteHistory(histories.value[indexPath.row])
    }
}
