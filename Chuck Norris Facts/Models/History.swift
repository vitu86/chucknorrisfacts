//
//  History.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import RealmSwift

class History : Object {
    @objc dynamic var value: String = ""
    
    convenience init(_ value: String) {
        self.init()
        self.value = value
    }
}
