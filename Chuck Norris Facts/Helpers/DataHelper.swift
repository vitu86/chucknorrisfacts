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

class DataHelper {
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DataHelper = DataHelper()
    
    // State to control views
    enum State {
        case Initial
        case Empty
        case Loading
        case FinishedLoading
    }
    
    // MARK: - Public Properties
    var loadingFactsState:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    var loadingSuggestionsState:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    var facts:BehaviorRelay<[Fact]> = BehaviorRelay<[Fact]>(value: [])
    var categories:BehaviorRelay<[Category]> = BehaviorRelay<[Category]>(value: [])
    var histories:BehaviorRelay<[History]> = BehaviorRelay<[History]>(value: [])
    
    
    // MARK: - Private Properties
    private let disposeBag:DisposeBag = DisposeBag()
    
    // private init for override purpose
    private init() {
    }
    
    // MARK: Public Functions
    func updateFacts(with query: String) {
        loadingFactsState.accept(.Loading)
        NetworkHelper.shared.getFacts(with: query) { (result) in
            self.facts.accept(result)
            if result.isEmpty {
                self.loadingFactsState.accept(.Empty)
            } else {
                self.loadingFactsState.accept(.FinishedLoading)
                DatabaseHelper.shared.saveHistory(query)
            }
        }
    }
    
    func updateCategories() {
        loadingSuggestionsState.accept(.Loading)
        
        categories.accept(DatabaseHelper.shared.getCategories())
        
        if categories.value.isEmpty {
            // If there's no cateogries on database, load from web
            NetworkHelper.shared.getCategories { (cats) in
                let categories = DatabaseHelper.shared.saveCategories(cats)
                self.categories.accept(categories)
                if self.categories.value.isEmpty {
                    self.loadingSuggestionsState.accept(.Empty)
                } else {
                    self.loadingSuggestionsState.accept(.FinishedLoading)
                }
            }
        } else {
            loadingSuggestionsState.accept(.FinishedLoading)
        }
    }
    
    func updateHistory() {
        histories.accept(DatabaseHelper.shared.getHistories())
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        let historyToDelete = histories.value[indexPath.row]
        histories.accept(DatabaseHelper.shared.deleteHistory(historyToDelete))
    }
}
