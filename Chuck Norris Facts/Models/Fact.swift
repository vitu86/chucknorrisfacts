//
//  Fact.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import ObjectMapper

class Fact: Mappable {
    var category: [String]?
    var url: String = ""
    var value: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category <- map["category"]
        url <- map["url"]
        value <- map["value"]
    }
}
