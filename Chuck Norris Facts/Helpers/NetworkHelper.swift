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
        AF.request("\(baseURL)/search?query=\(search)").responseArray(keyPath: "result") { (response: AFDataResponse<[Fact]>) in
            do {
                let facts = try response.result.get()
                onComplete(facts, nil)
            } catch {
                onComplete([], error.localizedDescription)
            }
        }
    }
    
    func getCategories(onComplete: @escaping ([String]) -> Void) {
        AF.request("\(baseURL)/categories").responseJSON { (response) in
            do {
                let resultValue = try response.result.get()
                if let categories = resultValue as? [String] {
                    onComplete(categories)
                } else {
                    onComplete([])
                }
            } catch {
                print("Error retrieving the categories: \(error)")
                onComplete([])
            }
        }
    }
}










