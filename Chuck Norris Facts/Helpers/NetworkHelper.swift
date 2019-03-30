//
//  NetworkHelper.swift
//  Chuck Norris Facts
//
//  Created by Vitor Costa on 30/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class NetworkHelper {
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:NetworkHelper = NetworkHelper()
    
    // MARK: - Private Properties
    private let baseURL:String = "https://api.chucknorris.io/jokes"
    
    // private init for override purpose
    private init() {
    }
    
    func getFacts(with search: String, onComplete: @escaping ([Fact], String?) -> Void) {
        Alamofire.request("\(baseURL)/search?query=\(search)").responseArray(keyPath: "result") { (response: DataResponse<[Fact]>) in
            if let result = response.result.value {
                onComplete(result, nil)
            } else {
                onComplete([], response.result.error?.localizedDescription)
            }
        }
    }
    
    func getCategories(onComplete: @escaping ([String], String?) -> Void) {
        Alamofire.request("\(baseURL)/categories").responseJSON { (response) in
            if let categories = response.result.value as? [String] {
                onComplete(categories, nil)
            } else {
                onComplete([], response.result.error?.localizedDescription)
            }
        }
    }
}










