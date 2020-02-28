//
//  VenuePhotoInfo.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/25/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct VenuePhotoInfo: Codable {
  let response: Response
}
struct Response: Codable {
  let photos: Photos
}
struct Photos: Codable & Equatable {
  let items: [PhotoItems]?
}
struct PhotoItems: Codable & Equatable {
  let prefix: String
  let suffix: String
  let width: Int
  let height: Int
}
