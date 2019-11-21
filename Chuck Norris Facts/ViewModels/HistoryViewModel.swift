//
//  HistoryViewModel.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 21/11/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import RxSwift

protocol HistoryViewModelProtocol {
    var subscriber:BehaviorSubject<[History]> { get }
}

class HistoryViewModel: HistoryViewModelProtocol {
    var subscriber: BehaviorSubject<[History]> = BehaviorSubject<[History]>(value: [])
    
    private var bag:DisposeBag!
    
    init(bag: DisposeBag) {
        self.bag = bag
        getFromDataBase()
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        do {
        try DatabaseHelper.shared.deleteHistory(subscriber.value()[indexPath.row])
        } catch {}
    }
    
    private func getFromDataBase() {
        let histories = DatabaseHelper.shared.getHistories()
        Observable.array(from: histories).map { array in
            return array.prefix(10)
            }.subscribe(onNext: { items in
                self.subscriber.onNext(Array(items))
            }).disposed(by: bag)
    }
}
