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
import RxRealm
import RealmSwift
import Realm

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: MDCTextField!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var suggestionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var searchTFController:MDCTextInputControllerOutlined!
    private var historyLoader: HistoryViewModel!
    
    // MARK: - Private Constants
    private let disposeBag:DisposeBag = DisposeBag()
    private let categoriesLoader: CategoryViewModel = CategoryViewModel()
    
    // MARK: - Injected Properties
    var factsLoader:FactViewModel!
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        historyLoader = HistoryViewModel(bag: disposeBag)
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        configureSearchTextField()
        configureHistoryTableView()
        configureSuggestionsCollectionView()
    }
    
    private func configureSearchTextField() {
        // Configure search textfield
        searchTFController = MDCTextInputControllerOutlined(textInput: searchTextField)
        searchTFController.activeColor = UIColor(named: "GreenDefault")
        searchTFController.floatingPlaceholderActiveColor = UIColor(named: "GreenDefault")
        searchTextField.delegate = self
    }
    
    private func searchFor(_ term: String) {
        factsLoader.getFacts(with: term)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Table View Support Functions
    private func configureHistoryTableView() {
        // Bind table view with data
        historyLoader.subscriber.asObservable().bind(to: historyTableView.rx.items(cellIdentifier: "HistoryCell", cellType: UITableViewCell.self)) { (row, element: History, cell) in
            self.fillHistoryCell(element, cell)
            }.disposed(by: disposeBag)
        
        // Did select item function
        historyTableView.rx.modelSelected(History.self)
            .subscribe(onNext:  { value in
                self.searchFor(value.value)
            })
            .disposed(by: disposeBag)
        
        // Slide to delete functions
        historyTableView.rx.itemDeleted.subscribe{
            if let indexPath = $0.element {
                self.historyLoader.deleteHistory(at: indexPath)
            }
            }.disposed(by: disposeBag)
    }
    
    private func fillHistoryCell (_ element: History, _ cell: UITableViewCell) {
        // Fill cell
        cell.textLabel?.text = element.value
        // Update height constraint so it doesn't create an inside scroll
        historyHeightConstraint.constant = historyTableView.contentSize.height
    }
    
    // MARK: Collection View Support Functions
    private func configureSuggestionsCollectionView() {
        // Bind collectionview to data
        categoriesLoader.subscriber.asObservable().bind(to: suggestionsCollectionView.rx.items(cellIdentifier: "SuggestionCell", cellType: SuggestionsCollectionViewCell.self)) { (row, element: Category, cell) in
            self.fillSuggestionCell(row, element, cell)
            }.disposed(by: disposeBag)
        
        // Did select item function
        suggestionsCollectionView.rx.modelSelected(Category.self)
            .subscribe(onNext:  { value in
                self.searchFor(value.name)
            })
            .disposed(by: disposeBag)
        // Delegates to left flow layout and item size
        suggestionsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        suggestionsCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        
        // Shuffle suggestions
        categoriesLoader.shuffleSuggestions()
    }
    
    private func fillSuggestionCell (_ row: Int, _ element: Category, _ cell: SuggestionsCollectionViewCell) {
        // Fill cell
        cell.setCategory(element.name)
        // Update height constraint so it doesn't create an inside scroll
        suggestionsHeightConstraint.constant = suggestionsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

// MARK: - Text Field Override Functions
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let search = textField.text {
            if search.isEmpty {
                showAlert(title: "Hey!", message: "Are you searching for nothing?")
            } else {
                self.searchFor(search)
            }
        }
        return true
    }
}

// MARK: - Collection View Layout Delegate Override Functions
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        do {
            var size: CGSize = try categoriesLoader.subscriber.value()[indexPath.row].name.uppercased().size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])
            size.width += 45 // Adjusting Text Insets
            size.height = 30
            return size
        } catch {
            return CGSize.zero
        }
    }
}
