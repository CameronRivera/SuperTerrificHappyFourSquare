//
//  SuperTerrificHappyFourSquareTests.swift
//  SuperTerrificHappyFourSquareTests
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import XCTest
import NetworkHelper
@testable import SuperTerrificHappyFourSquare

class SuperTerrificHappyFourSquareTests: XCTestCase {
    
    func testAPIClient() {
        let expectedName = "Brooklyn Academy of Music (BAM)"
        let query = "music"
        let exp = XCTestExpectation(description: "Found BAM")
        
        
        FourSquareAPIClient.getRestaurants(query: query) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let venues):
                XCTAssertEqual(venues.first?.name, expectedName)
                exp.fulfill()
            }
        }
         wait(for: [exp], timeout: 5.0)
    }
    
   

}
