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
    var histories:BehaviorRelay<[History]> = BehaviorRelay<[History]>(value: [])
    
    // MARK: - Private Properties
    private let disposeBag:DisposeBag = DisposeBag()
    
    // private init for override purpose
    private init() {
        bindHistories()
    }
    
    // MARK: Private Functions
    private func bindHistories() {
        DatabaseHelper.shared.bindHistories(with: histories, and: disposeBag)
    }
    
    // MARK: Public Functions    
    func deleteHistory(at indexPath: IndexPath) {
        DatabaseHelper.shared.deleteHistory(histories.value[indexPath.row])
    }
}
