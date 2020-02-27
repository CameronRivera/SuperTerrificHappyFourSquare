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
    
    func testVenueDataRetrievalMethod1() {
        let expectedName = "Brooklyn Academy of Music (BAM)"
        let location = "Queens"
        let query = "music"
        let exp = XCTestExpectation(description: "Found BAM")
        
        
        FourSquareAPIClient.getVenuesWithoutCoordinates(query: query, location: location) { (result) in
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
    
    func testVenueDataRetrievalMethod2() {
        let expectedName = "Radio City Music Hall"
        let query = "music"
        let latitude = "40.74224"
        let longitude = "-73.99386"
        let exp = XCTestExpectation(description: "Found Radio City Music Hall")
        
        FourSquareAPIClient.getVenuesWithCoordinates(query: query, latitude: latitude, longitude: longitude) { (result) in
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
    
    func testVenueDetailsFunc() {
        
        let venueID = "44127a5ff964a520d2301fe3"
        let expPhoneNumber = "(718) 636-4100"
        let exp = XCTestExpectation(description: "Found Correct Phone Number")
        
        FourSquareAPIClient.getVenueDetails(venueID: venueID) { (result) in
            switch result {
            case .failure(let appError):
            XCTFail("\(appError)")
            case .success(let venueDetails):
                XCTAssertEqual(venueDetails.response.venue.contact.formattedPhone, expPhoneNumber)
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
