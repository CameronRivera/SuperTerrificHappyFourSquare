//
//  ExtendedVenueInfo.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/26/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct ExtendedVenueInfo: Codable & Equatable {
    let response: VenueResponse
}

struct VenueResponse: Codable & Equatable {
    let venue: VenueDetails
}

struct VenueDetails: Codable & Equatable {
    let id: String
    let name: String
    let contact: ContactInfo
    let location: LocationInfo
    let url: String?
    let canonicalUrl: String?
    let rating: Double?
    let popular: PopularInfo?
    let categories: [VenueCategories]?
    let attributes: Attribute?
    let photos: Photos
    let hours: OperationStatus?
    let bestPhoto: PhotoItems
}

struct VenueCategories: Codable & Equatable {
    let pluralName: String
}

struct ContactInfo: Codable & Equatable {
    let  formattedPhone: String?
    // let twitter: String
    // let instagram: String
    // let faceboookName: String
}

struct LocationInfo: Codable & Equatable {
    let address: String
    let lat: Double
    let lng: Double
    let postalCode: String
    let cc: String
    let city: String
    let state: String
    let country: String
}


struct PopularInfo: Codable & Equatable {
    let isOpen: Bool
    let timeFrames: [TimeFrames]
    
     enum CodingKeys: String, CodingKey {
        case isOpen
        case timeFrames = "timeframes"
    }
}

struct TimeFrames: Codable & Equatable {
    let days: String
    let open: [OpenHours]
}

struct OpenHours: Codable & Equatable {
    let renderedTime: String
}

struct OperationStatus: Codable & Equatable {
    let status: String
}

struct Attribute: Codable & Equatable {
    let groups: [Group]
}

struct Group: Codable & Equatable {
    let type: String
    let summary: String?
}
