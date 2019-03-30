//
//  HomeViewController.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 26/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    // Private Properties
    private var facts: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: []) // Temp while have no model
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - ViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Fill temp content
        for _ in 0 ..< 4 {
            facts.accept(facts.value + ["a"])
        }
        
        // Observable to get cells
        facts.asObservable()
            .bind(to: tableview.rx.items(cellIdentifier: "FactsCell", cellType: FactsTableViewCell.self)) { (row, element, cell) in
                self.fillCell(row: row, element: element, cell: cell)
            }
            .disposed(by: disposeBag)
        
        // Function called when item selected
        tableview.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.shareURL(value)
            })
            .disposed(by: disposeBag)
    }
    
    private func fillCell (row: Int, element: String, cell: FactsTableViewCell) {
        let rand = Int.random(in: 60 ... 90)
        var text:String = ""
        for _ in 0 ..< rand {
            text += "a"
        }
        cell.setFact(text)
        cell.setCategory("category")
    }
    
    private func shareURL(_ url: String) {
        guard let url = URL(string: "http://www.google.com") else {
            return
        }
        let shareItens = [url]
        let activityViewController = UIActivityViewController(activityItems: shareItens, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
