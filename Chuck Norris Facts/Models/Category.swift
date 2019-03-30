//
//  Category.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
}
