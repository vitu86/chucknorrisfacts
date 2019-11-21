//
//  CategoryViewModel.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 20/11/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryViewModelProtocol {
    var subscriber:BehaviorSubject<[Category]> { get }
    func shuffleSuggestions()
}

class CategoryViewModel: CategoryViewModelProtocol {
    
    var subscriber: BehaviorSubject<[Category]> = BehaviorSubject<[Category]>(value: [])
    
    init() {
        initSuggestions()
    }
    
    private func initSuggestions() {
        let dbResult = DatabaseHelper.shared.getCategories()
        if dbResult.count <= 0 {
            updateCategories()
        } else {
            subscriber.onNext(dbResult)
        }
    }
    
    private func updateCategories() {
        NetworkHelper.shared.getCategories { (cats) in
            let categories = DatabaseHelper.shared.saveCategories(cats)
            self.subscriber.onNext(categories)
        }
    }
    
    func shuffleSuggestions() {
        subscriber.onNext(DatabaseHelper.shared.getCategories())
    }
}
