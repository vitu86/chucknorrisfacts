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
    
    // State to control views
    enum State {
        case Initial
        case Empty
        case Loading
        case FinishedLoading
        case Error
    }
    
    // MARK: - Public Properties
    var loadingFactsState:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    var facts:BehaviorRelay<[Fact]> = BehaviorRelay<[Fact]>(value: [])
    var categories:BehaviorRelay<[Category]> = BehaviorRelay<[Category]>(value: [])
    var histories:BehaviorRelay<[History]> = BehaviorRelay<[History]>(value: [])
    var loadingError:String? = nil
    
    
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
    func updateFacts(with query: String) {
        loadingFactsState.accept(.Loading)
        NetworkHelper.shared.getFacts(with: query) { (result, error) in
            if let error = error {
                self.loadingError = error
                self.loadingFactsState.accept(.Error)
            } else {
                self.facts.accept(result)
                if result.isEmpty {
                    self.loadingFactsState.accept(.Empty)
                } else {
                    self.loadingFactsState.accept(.FinishedLoading)
                    DatabaseHelper.shared.saveHistory(query)
                }
            }
        }
    }
    
    func shuffleSuggestions() {
        categories.accept(DatabaseHelper.shared.getCategories())
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        DatabaseHelper.shared.deleteHistory(histories.value[indexPath.row])
    }
}
