//
//  FactViewModel.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 20/11/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ObjectMapper


// State to control views
enum State {
    case Initial
    case Loading
    case FinishedLoading
}

protocol FactViewModelProtocol {
    var subscriber:BehaviorSubject<[Fact]> { get }
    var loadingFactsState:BehaviorSubject<State>{ get }
    func getFacts(with term: String)
}

class FactViewModel: FactViewModelProtocol {
    
    var subscriber: BehaviorSubject<[Fact]> = BehaviorSubject<[Fact]>(value: [])
    var loadingFactsState:BehaviorSubject<State> = BehaviorSubject<State>(value: .Initial)
    
    private var viewController:UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func getFacts(with term: String) {
        self.loadingFactsState.onNext(.Loading)
        NetworkHelper.shared.getFacts(with: term) { (result, error) in
            if let error = error {
                self.loadingFactsState.onNext(.Initial)
                self.viewController.showAlert(title: "Error", message: error)
            } else {
                self.subscriber.onNext(result)
                if result.isEmpty {
                    self.loadingFactsState.onNext(.Initial)
                    self.viewController.showAlert(title: "Sorry", message: "There are no results for this search: \(term)")
                } else {
                    self.loadingFactsState.onNext(.FinishedLoading)
                    DatabaseHelper.shared.saveHistory(term)
                }
            }
        }
    }
}
