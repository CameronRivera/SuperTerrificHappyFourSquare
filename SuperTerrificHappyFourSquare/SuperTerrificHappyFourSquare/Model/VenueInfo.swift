//
//  VenueInfo.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct VenueData: Codable & Equatable {
    let response: VenueInfo
}

struct VenueInfo: Codable & Equatable {
    let venues: [Venue]
}

struct Venue: Codable & Equatable {
    let id: String
    let name: String
    let location: Location
    let categories: [Category]
//    let referralID: ReferralID
    let hasPerk: Bool
    let venuePage: VenuePage?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case categories
//        case referralID = "referralId"
        case hasPerk, venuePage
    }
}

struct Location: Codable & Equatable {
    let address, crossStreet: String?
    let lat: Double
    let lng: Double
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String
    let formattedAddress: [String]
    let neighborhood: String?
}

struct Category: Codable & Equatable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: Icon
    let primary: Bool
}

struct Icon: Codable & Equatable {
    let iconPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

struct VenuePage: Codable & Equatable {
    let id: String
}




