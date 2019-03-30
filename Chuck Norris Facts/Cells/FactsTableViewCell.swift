//
//  FactsTableViewCell.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 29/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class FactsTableViewCell: UITableViewCell {
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var categoryLabel: EdgeInsetLabel!
    
    func setFact(_ fact:String) {
        factLabel.text = fact
        
        if fact.count > 80 {
            factLabel.font = factLabel.font.withSize(17)
        } else {
            factLabel.font = factLabel.font.withSize(20)
        }
    }
    
    func setCategory(_ category:String) {
        categoryLabel.text = category.uppercased()
    }
}
