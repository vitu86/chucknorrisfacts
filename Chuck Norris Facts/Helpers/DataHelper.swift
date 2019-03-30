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
    }
    
    // MARK: - Public Properties
    var facts:BehaviorRelay<[Fact]> = BehaviorRelay<[Fact]>(value: [])
    var loadingFactsState:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    var loadingSuggestionsState:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    var categories:BehaviorRelay<[Category]> = BehaviorRelay<[Category]>(value: [])
    
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
            }
        }
    }
    
    func updateCategories() {
        loadingSuggestionsState.accept(.Loading)
        
        if let realm = try? Realm() {
            var categs = realm.objects(Category.self).toArray()
            categs.shuffle()
            categories.accept(Array(categs.prefix(8)))
        }
        
        if categories.value.isEmpty {
            NetworkHelper.shared.getCategories { (cats) in
                var realmCategories = cats.map({ (item) -> Category in
                    return Category(item)
                })
                
                Observable.from(optional: realmCategories).subscribe(Realm.rx.add()).disposed(by: self.disposeBag)
                realmCategories.shuffle()
                self.categories.accept(Array(realmCategories.prefix(8)))
                
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
}
