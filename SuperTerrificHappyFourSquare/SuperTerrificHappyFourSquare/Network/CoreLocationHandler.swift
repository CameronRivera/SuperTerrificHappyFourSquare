//
//  CoreLocationHandler.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationHandler: NSObject{
    
    public var locationManager: CLLocationManager
    
    override init(){
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        startSignificantLocationChanges()
        startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges(){
        if !CLLocationManager.significantLocationChangeMonitoringAvailable(){
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func startMonitoringRegion(){
        // Create a location
        let location = CLLocationCoordinate2D(latitude: 43.32419, longitude: -73.23490)
        let identifier = "Fabricated Region"
        let region = CLCircularRegion(center: location, radius: 100, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        locationManager.startMonitoring(for: region)
    }
    
    public func convertCoordinateToPlacemark(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark,Error>) -> () ){
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("ReverseGeolocationError: \(error)")
                completion(.failure(error))
            }
            
            if let firstMark = placemarks?.first{
                print("Placemark Information: \(firstMark)")
                completion(.success(firstMark))
            }
        }
    }
    
    public func convertPlaceNameToCoordinate(_ placeName: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> ()){
        CLGeocoder().geocodeAddressString(placeName) { placemarks, error in
            if let error = error{
                print("Geocode Address Error: \(error)")
                completion(.failure(error))
            }
            
            if let firstMark = placemarks?.first,
                let location = firstMark.location {
                print("Placename Coordinate is: \(location.coordinate)")
                completion(.success(location.coordinate))
            }
        }
    }
}

extension CoreLocationHandler: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
}
