//
//  SuggestionsCollectionViewCell.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 29/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

class SuggestionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: EdgeInsetLabel!
    
    func setCategory(_ category:String) {
        categoryLabel.text = category.uppercased()
    }
}
