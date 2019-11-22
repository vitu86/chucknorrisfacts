//
//  NetworkHelperUnitTests.swift
//  Chuck Norris FactsTests
//
//  Created by Vitor Costa on 21/11/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import XCTest

class NetworkHelperUnitTests: XCTestCase {
    
    let correctSearchWithResult: String = "animal"
    let correctSearchWithoutResult: String = "sdfhsihufjfhjsehje"
    let uncorrectSeach: String = "grçl~´´]//pó"
    
    func testGetCorrectFacts() {
        let expectation = self.expectation(description: "Get Correct Facts")
        var answers: [Fact] = []
        var error: String? = nil
        
        NetworkHelper.shared.getFacts(with: correctSearchWithResult) { (result, errorResult) in
            answers = result
            error = errorResult
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        XCTAssertTrue(!answers.isEmpty && error == nil)
    }
    
    func testGetCorrectFactsEmpty() {
        let expectation = self.expectation(description: "Get Correct Facts Empty")
        var answers: [Fact] = []
        var error: String? = nil
        
        NetworkHelper.shared.getFacts(with: correctSearchWithoutResult) { (result, errorResult) in
            answers = result
            error = errorResult
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        XCTAssertTrue(answers.isEmpty && error == nil)
    }
    
    func testGetUncorrectFacts() {
        let expectation = self.expectation(description: "Get Uncorrect Facts")
        var answers: [Fact] = []
        var error: String? = nil
        
        NetworkHelper.shared.getFacts(with: uncorrectSeach) { (result, errorResult) in
            answers = result
            error = errorResult
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        XCTAssertTrue(answers.isEmpty && error != nil)
    }
}
