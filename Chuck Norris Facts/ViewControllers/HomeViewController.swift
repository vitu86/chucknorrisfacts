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
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var initialContainer: UIView!
    
    // MARK: - Private Contants
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - ViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Hide the back button title on next view controller
        hideNextTitleButtonNavBar()
        
        // Switch views if empty/initial state
        DataHelper.shared.loadingFactsState.asObservable().subscribe { (next) in
            if let state = next.element {
                self.changeViewAccordingToState(state)
            }
        }.disposed(by: disposeBag)
        
        // Observable to get cells
        DataHelper.shared.facts.asObservable().bind(to: tableview.rx.items(cellIdentifier: "FactsCell", cellType: FactsTableViewCell.self)) { (row, element:Fact, cell) in
                self.fillCell(row: row, element: element, cell: cell)
            }
            .disposed(by: disposeBag)
        
        // Function called when item selected
        tableview.rx
            .modelSelected(Fact.self)
            .subscribe(onNext:  { value in
                self.shareURL(value.url)
            })
            .disposed(by: disposeBag)
    }
    
    private func fillCell (row: Int, element: Fact, cell: FactsTableViewCell) {
        cell.setFact(element.value)
        if let category = element.category?[0] {
            cell.setCategory(category)
        } else {
            cell.setCategory("uncategorized")
        }
    }
    
    private func shareURL(_ address: String) {
        guard let url = URL(string: address) else {
            showAlert(title: "Sorry", message: "Can't share this url fact: \(address)")
            return
        }
        let shareItens = [url]
        let activityViewController = UIActivityViewController(activityItems: shareItens, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func changeViewAccordingToState (_ state: DataHelper.State) {
        
        self.hideCenterIndicator()
        self.initialContainer.isHidden = true
        self.tableview.isHidden = true
        
        switch state {
        case .Initial:
            self.initialContainer.isHidden = false
        case .Empty:
            self.showAlert(title: "Sorry", message: "There are no results for this search", okFunction: { (_) in
                DataHelper.shared.loadingFactsState.accept(.Initial)
            }, cancelFunction: nil)
        case .Loading:
            self.showCenterIndicator()
        case .FinishedLoading:
            self.tableview.isHidden = false
            self.hideCenterIndicator()
        }
    }
}
