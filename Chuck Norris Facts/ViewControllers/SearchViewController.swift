//
//  SearchViewController.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 29/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import DGCollectionViewLeftAlignFlowLayout
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: MDCTextField!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var suggestionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var searchTFController:MDCTextInputControllerOutlined!
    private var history:BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: []) // Temp while have no model
    
    // MARK: - Private Constants
    private let disposeBag:DisposeBag = DisposeBag()
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func loadData() {
        DataHelper.shared.updateCategories()
    }
    
    private func configureUI() {
        // Switch views if empty/loading state
        DataHelper.shared.loadingSuggestionsState.asObservable().subscribe { (next) in
            if let state = next.element {
                self.changeViewAccordingToState(state)
            }
        }.disposed(by: disposeBag)
        
        // Configure search textfield
        searchTFController = MDCTextInputControllerOutlined(textInput: searchTextField)
        searchTFController.activeColor = UIColor(named: "GreenDefault")
        searchTFController.floatingPlaceholderActiveColor = UIColor(named: "GreenDefault")
        searchTextField.delegate = self
        
        // Configure History
        history.asObservable().bind(to: historyTableView.rx.items(cellIdentifier: "HistoryCell", cellType: UITableViewCell.self)) { (row, element, cell) in
            self.fillHistoryCell(row, element, cell)
            }.disposed(by: disposeBag)
        
        historyTableView.rx.modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.onHistoryTapped(value)
            })
            .disposed(by: disposeBag)
        
        // Configure Suggestions
        DataHelper.shared.categories.asObservable().bind(to: suggestionsCollectionView.rx.items(cellIdentifier: "SuggestionCell", cellType: SuggestionsCollectionViewCell.self)) { (row, element:Category, cell) in
            self.fillSuggestionCell(row, element, cell)
        }.disposed(by: disposeBag)
        
        suggestionsCollectionView.rx.modelSelected(Category.self)
            .subscribe(onNext:  { value in
                self.onSuggestionTapped(value)
            })
            .disposed(by: disposeBag)
        suggestionsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionsCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
    }
    
    private func changeViewAccordingToState (_ state: DataHelper.State) {
        self.hideCenterIndicator()
        if state == .Empty {
            suggestionsHeightConstraint.constant = 0
            self.showAlert(title: "Sorry", message: "There are no suggestions available")
        } else if state == .Loading {
            self.showCenterIndicator()
        }
    }
    
    // MARK: Table View Support Functions
    private func fillHistoryCell (_ row: Int, _ element: String, _ cell: UITableViewCell) {
        // Fill cell
        cell.textLabel?.text = "Teste \(row)"
        // Update height constraint so it doesn't create an inside scroll
        historyHeightConstraint.constant = historyTableView.contentSize.height
    }
    
    private func onHistoryTapped(_ string: String) {
        print("Table view tapped")
    }
    
    // MARK: Collection View Support Functions
    private func fillSuggestionCell (_ row: Int, _ element: Category, _ cell: SuggestionsCollectionViewCell) {
        // Fill cell
        cell.setCategory(element.name)
        // Update height constraint so it doesn't create an inside scroll
        suggestionsHeightConstraint.constant = suggestionsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func onSuggestionTapped(_ string: Category) {
        print("Collection view tapped")
    }
}

// MARK: - Text Field Override Functions
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Collection View Layout Delegate Override Functions
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = DataHelper.shared.categories.value[indexPath.row].name.uppercased().size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])
        size.width += 45 // Adjusting Text Insets
        size.height = 30
        return size
    }
}
