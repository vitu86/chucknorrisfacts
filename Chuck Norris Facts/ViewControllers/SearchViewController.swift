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

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: MDCTextField!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var suggestionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var searchTFController:MDCTextInputControllerOutlined!
    
    // TEMP
    private var content:[String] = []
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< 8 {
            let random = Int.random(in: 5 ... 10)
            var text:String = ""
            for _ in 0 ..< random {
               text.append("a")
            }
            content.append(text)
        }
        
        
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure search textfield
        searchTFController = MDCTextInputControllerOutlined(textInput: searchTextField)
        searchTFController.activeColor = UIColor(named: "GreenDefault")
        searchTFController.floatingPlaceholderActiveColor = UIColor(named: "GreenDefault")
        searchTextField.delegate = self
        
        // Configure History
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.reloadData()
        historyHeightConstraint.constant = historyTableView.contentSize.height
        
        // Configure Suggestions
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        suggestionsCollectionView.reloadData()
        suggestionsHeightConstraint.constant = suggestionsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

// MARK: - Text Field Override Functions
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Table View Override Functions
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")!
        cell.textLabel?.text = "Teste \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("History item selected")
        // TODO: Load item
    }
}

// MARK: - Collection View Override Functions
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionsCollectionViewCell
        cell.setCategory(content[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = content[indexPath.row].uppercased().size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])
        size.width += 50 // Adjusting Text Insets
        size.height = 48 // Apple minimum button height
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Suggestion item selected")
        // TODO: Load item
    }
}
