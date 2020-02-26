//
//  ViewController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import DataPersistence

class SearchController: UIViewController {
    
    //let dataPersistance: DataPersistence<Venue>
    
    private var searchView = SearchView()
    
    private var location = [Location]()
    
    //private var mapView = MKMapView()
    
    private var venus = [Venue](){
        didSet{
            DispatchQueue.main.async {
                
            }
        }
    }
    
    private var venuePhoto = [PhotoItems](){
        didSet{
            DispatchQueue.main.async {
                
            }
        }
    }
    
    private let locationSession = CoreLocationHandler()
    
    var userTrackingButton: MKUserTrackingButton!
    
    var annotations = [MKPointAnnotation]()
    
    let searchRadius: CLLocationDistance = 100.0
    
    private var isShowingNewAnnotations = false
    
    
    override func loadView() {
        view = searchView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.backgroundColor = .systemBackground
        //loadMap()
        setUp()
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        userTrackingButton.mapView = searchView.mapView
        searchView.mapView.addSubview(userTrackingButton)
        
        loadData(searchQuery: "pizza")
        
    }
    
    private func setUp(){
        searchView.venuesCollectionView.dataSource = self
        searchView.venuesCollectionView.delegate = self
        searchView.venuesCollectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCollectCell")
    }
    
    private func loadData(searchQuery: String){
        FourSquareAPIClient.getVenues(query: searchQuery) { (result) in
            switch result {
            case .failure(let error):
                print("\(error)")
            case .success(let venue):
                self.venus = venue
                self.loadPhoto(venueID: venue.first?.id ?? "no id avalable" )
            }
        }
    }
    
    private func loadPhoto(venueID: String){
        FourSquareAPIClient.getVenuePhotos(venueID: venueID) { (result) in
            switch result {
            case .failure(let error):
                print("\(error)")
            case .success(let photo):
                self.venuePhoto = photo
                // www.(prefix)/(width)x(height)/(suffix)
                
            }
        }
    }
    
    
    @objc func listButtonPressed(){
        let cv = CategoryController()
        self.modalPresentationStyle = .fullScreen
        present(cv, animated: true)
    }
    
    
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in venus {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            //annotation.coordinate = location(location.l)
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
    }
    
    private func convertPlaceNameToCoordinate(_ placeName: String, completetion: @escaping (Result<CLLocationCoordinate2D, Error>) -> ()) {
        CLGeocoder().geocodeAddressString(placeName) { (placemarks, error) in
            if let error = error {
                completetion(.failure(error))
            }
            if let firstPlacemark = placemarks?.first,
                let location = firstPlacemark.location {
                print("placeName is \(location.coordinate)")
                completetion(.success(location.coordinate))
            }
        }
        
        //        locationSession.convertPlaceNameToCoordinate(addressString: placeName) { (result) in
        //            switch result {
        //            case .failure(let error):
        //                print("geocode error: \(error)")
        //            case .success(let coordinate):
        //                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200)
        //                self.mapView.setRegion(region, animated: true)
        //            }
        //        }
        //    }
        
        
        func loadMap() {
            let annotations = makeAnnotations()
            searchView.mapView.addAnnotations(annotations)
            searchView.mapView.showAnnotations(annotations, animated: true)
        }
        
        func loadNearbyVenue(){
            
        }
        
        
        //    private func convertPlaceNameToCoordinate(_ placeName: String) {
        //        locationSession.convertCoordinateToPlacemark(<#T##coordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>) { (result) in
        //            switch result {
        //            case .failure(let error):
        //                print("geocode error: \(error)")
        //            case .success(let coordinate):
        //                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200)
        //                self.mapView.setRegion(region, animated: true)
        //            }
        //        }
        //    }
        
    }
}
//---------------------------------------------------------------
//MARK: EXTENSIONS

extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {return}
        
        let location = ""
        
        let searchQuery = ""
        
        
        
        
        //guard let detailVC =
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(named: "alexHead")
        }else{
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
// MARK: EXTENSIONS

//extension SearchController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        guard let searchText = textField.text,!searchText.isEmpty else {
//            return true
//        }
//        convertPlaceNameToCoordinate(searchText) { (result) in
//            switch result {
//            case .failure(let error):
//                print("\(error)")
//            case .success(let queryResults):
//                let query = textField.text.
//            }
//        }
//        return true
//    }
//}

extension SearchController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        venus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "venueCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("could not cast to cell")
        }
        let venue = venus[indexPath.row]
        cell.configureMKViewCollectionCell(venue.id)
        
        return cell
    }
    
}

extension SearchController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let venu = venus[indexPath.row]
        let detailVC = DetailViewController()
        
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing: CGFloat = 0.2
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 1
        let totalSpace: CGFloat = numberOfItems * itemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpace) / 1
        return CGSize(width: itemWidth/2, height: itemWidth/1.5)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    }
}
