//
//  DataHelper.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RxCocoa

class DataHelper {
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DataHelper = DataHelper()
    
    // MARK: Public Properties
    var facts:BehaviorRelay<[Fact]> = BehaviorRelay<[Fact]>(value: [])
    var state:BehaviorRelay<State> = BehaviorRelay<State>(value: .Initial)
    
    enum State {
        case Initial
        case Empty
        case Loading
        case FinishedLoading
    }
    
    // private init for override purpose
    private init() {
    }
    
    // MARK: Public Functions
    func updateFacts(with query: String) {
        state.accept(.Loading)
        NetworkHelper.shared.getFacts(with: query) { (result) in
            self.facts.accept(result)
            if result.count > 0 {
                self.state.accept(.FinishedLoading)
            } else {
                self.state.accept(.Empty)
            }
        }
    }
}
