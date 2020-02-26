//
//  ExtendedVenueInfo.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/26/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct ExtendedVenueInfo: Codable {
    
    let response: VenueResponse
}

struct VenueResponse: Codable {
    
    let venue: VenueDetails
    
    
}

struct VenueDetails: Codable {
    let id: String
    let  name: String
    let contact: ContactInfo
    let  location: LocationInfo
    let url: String
    let rating: Double
    let popular: PopularInfo
    
}

struct ContactInfo: Codable {
    let  formattedPhone: String
    // let twitter: String
    // let instagram: String
    // let faceboookName: String
}

struct LocationInfo: Codable {
    let address: String
    let lat: Double
    let lng: Double
    let  postalCode: String
    let cc: String
    let city: String
    let  state: String
    let country: String
}


struct PopularInfo: Codable {
    let isOpen: Bool
    let timeFrames: [TimeFrames]
    
     enum CodingKeys: String, CodingKey {
        case isOpen
        case timeFrames = "timeframes"
    }
}

struct TimeFrames: Codable {
    let days: String
    let open: [OpenHours]
}

struct OpenHours: Codable {
    let renderedTime: String
}
