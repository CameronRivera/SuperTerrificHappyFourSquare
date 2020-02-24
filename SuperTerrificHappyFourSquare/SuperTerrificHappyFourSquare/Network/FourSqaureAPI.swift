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
    
    
    
    static func getRestaurants(query: String, completion: @escaping (Result<[Venue], AppError>) -> ()){
        
       
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(APIKeyclientID)&client_secret=\(APIKey.clientSecret)&v=20200221&near=Queens&query=\(query)"
        
    
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        
        let request = URLRequest(url: url)
        
       
        
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
}
