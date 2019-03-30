//
//  HomeViewController.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 26/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    // MARK: - ViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        tableview.dataSource = self
        tableview.delegate = self
        
        hideNextTitleButtonNavBar()
    }
}

// MARK: - Table View Override Functions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactsCell") as! FactsTableViewCell
        
        let rand = Int.random(in: 60 ... 490)
        var text:String = ""
        
        for _ in 0 ..< rand {
            text += "a"
        }
        
        cell.setFact(text)
        cell.setCategory("category")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: "http://www.google.com") else {
            return
        }
        let shareItens = [url]
        let activityViewController = UIActivityViewController(activityItems: shareItens, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
