//
//  FourSqaureAPI.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import NetworkHelper

struct FourSquareAPIClient {
    
    
    
    static func getVenuesWithoutCoordinates (query: String, location: String, completion: @escaping (Result<[Venue], AppError>) -> ()){
        
        
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(APIKey.clientID)&client_secret=\(APIKey.clientSecret)&v=20200221&near=\(location)&query=\(query)"
        
        // Think about how to guard/remove/replace non-alphabet strings/characters to be placed into endpoint url
        
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        
        let request = URLRequest(url: url)
        
        print("this is my query \(query)")
        
        print("this is my location \(location)")
        
        print(url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode(VenueData.self, from: data)
                    completion(.success(search.response.venues))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        
    }
    
    static func getVenuesWithCoordinates(query: String, latitude: String, longitude: String, completion: @escaping (Result<[Venue], AppError>) -> ()) {
        
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(APIKey.clientID)&client_secret=\(APIKey.clientSecret)&v=20170210&ll=\(latitude),\(longitude)&query=\(query)"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (request) in
            switch request {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode(VenueData.self, from: data)
                    completion(.success(search.response.venues))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        
    }
    
    static func getVenuePhotos(venueID: String, completion: @escaping (Result<[PhotoItems], AppError>) -> ()) {
        
        
        let endpointURL = "https://api.foursquare.com/v2/venues/\(venueID)/photos?client_id=\(APIKey.clientID)&client_secret=\(APIKey.clientSecret)&v=20202010&VENUE_ID=\(venueID)"
        
        guard let url = URL(string: endpointURL) else { completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                do {
                    // let search = try JSONDecoder().decode(VenueData.self, from: data)
                    let photoInfo = try JSONDecoder().decode(VenuePhotoInfo.self, from: data)
                    completion(.success(photoInfo.response.photos.items ?? []))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
    static func getVenueDetails(venueID: String , completion: @escaping (Result<ExtendedVenueInfo, AppError>) -> ()) {
        let endpointURL = "https://api.foursquare.com/v2/venues/\(venueID)?client_id=\(APIKey.clientID)&client_secret=\(APIKey.clientSecret)&v=20200210"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (request) in
            switch request {
            case .failure(let appError):
                completion(.failure(.decodingError(appError)))
            case .success(let data):
                do {
                    let venueDetails = try JSONDecoder().decode(ExtendedVenueInfo.self, from: data)
                    completion(.success(venueDetails))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        
    }
    
}
