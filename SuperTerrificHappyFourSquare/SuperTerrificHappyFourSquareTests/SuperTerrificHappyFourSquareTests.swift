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
    
    func testVenueDataRetrieval() {
        let expectedName = "Brooklyn Academy of Music (BAM)"
        let query = "music"
        let exp = XCTestExpectation(description: "Found BAM")
        
        
        FourSquareAPIClient.getVenues(query: query) { (result) in
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
    
    func testPhotoDataRetrieval() {
        let expectedPrefix = "https://fastly.4sqi.net/img/general/"
        let venueID = "44127a5ff964a520d2301fe3"
        let exp = XCTestExpectation(description: "Correct count")
        
        FourSquareAPIClient.getVenuePhotos(venueID: venueID) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let venuePhoto):
                XCTAssertEqual(venuePhoto.first?.prefix, expectedPrefix)
                exp.fulfill()
            }
            
        }
        wait(for: [exp], timeout: 5.0)
    }

}
