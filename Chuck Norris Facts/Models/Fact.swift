//
//  Fact.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import ObjectMapper

class Fact: Mappable {
    var categories: [String]?
    var url: String = ""
    var value: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        categories <- map["categories"]
        url <- map["url"]
        value <- map["value"]
    }
}
