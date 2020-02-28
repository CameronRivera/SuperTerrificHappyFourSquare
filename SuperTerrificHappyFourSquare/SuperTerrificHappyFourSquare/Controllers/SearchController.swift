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
import ImageKit

class SearchController: UIViewController {
    
    //let dataPersistance: DataPersistence<Venue>
    
    private var searchView = SearchView()
    
    var mapView = MKMapView()
    
    private var location = [Location]()
    
//    private var searchQuery = "" {
//        didSet{
//            DispatchQueue.main.async {
//                self.getVenueWOCoordinate(query: "", location: "")
//                self.loadMap()
//            }
//        }
//    }
//
//    private var locationQuery = ""  {
//        didSet{
//            DispatchQueue.main.async {
//                self.getVenueWOCoordinate(query: "", location: "")
//                self.loadMap()
//            }
//        }
//    }
    
    private var venus = [Venue](){
        didSet{
            DispatchQueue.main.async {
                self.loadMap()
            }
        }
    }
    
    private var venuePhoto = [PhotoItems](){
        didSet{
            DispatchQueue.main.async {
                self.loadPhoto(venueID: "")
            }
        }
    }
    
  
    
    private let locationSession = CoreLocationHandler()
    
    var userTrackingButton: MKUserTrackingButton!
    
    var defaultLocation = ""
    
    var annotations = [MKPointAnnotation]()
    
    let searchRadius: CLLocationDistance = 100.0
    
    
    private var isShowingNewAnnotations = false
    
    
    override func loadView() {
        view = searchView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.backgroundColor = .systemBackground
        setUp()
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        userTrackingButton.mapView = searchView.mapView
        searchView.mapView.addSubview(userTrackingButton)
       // loadMap()
//        getVenueWOCoordinate(query: "", location: "")
        mapView.delegate = self
        searchView.venueSearchBar.delegate = self
        searchView.locationSearch.delegate = self
        locationSession.delegate = self
    }
    
    
    
    private func setUp(){
        searchView.venuesCollectionView.dataSource = self
        searchView.venuesCollectionView.delegate = self
        searchView.venuesCollectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCollectCell")
    }
    
    
    
    private func getVenueWOCoordinate(query: String, location: String){
        
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "McDonalds"
        
        let searchLocation = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Queens"
        
        FourSquareAPIClient.getVenuesWithoutCoordinates(query: query, location: location) { (result) in

            switch result {
            case .failure(let error):
                print("This is an error I wrote in the API call \(error) CHECK. CHECK")
            case .success(let venue):
                self.venus = venue
                print(self.venus)
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
        let cv = DetailViewController()
        self.modalPresentationStyle = .fullScreen
        present(cv, animated: true)
    }
    
    private func loadMap() {
        let annotations = makeAnnotations()
        // mapView.addAnnotations(annotations)
        searchView.mapView.addAnnotations(annotations)
        searchView.mapView.showAnnotations(annotations, animated: true)
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in venus {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.coordinate.latitude = location.location.lat
            annotation.coordinate.longitude = location.location.lng
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
    }
    
    private func convertPlaceNameToCoordinate(_ placeName: String) {
        locationSession.convertPlaceNameToCoordinate(placeName) { (result) in
            switch result {
            case .failure(let error):
                print("geocode error: \(error)")
            case .success(let coordinate):
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
                self.searchView.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func loadUserLocation(_ position: CLLocation){
        locationSession.convertCoordinateToPlacemark(position.coordinate) { (result) in
            switch result {
            case .failure(let error):
                print("error finding user location: \(error)")
            case .success(let location):
                self.defaultLocation = location.name ?? ""
                print(location.name)
            }
        }
    }
    
    
    func textFieldSelector(_ textField: UITextField) {
        
        if textField == searchView.locationSearch {
            getVenueWOCoordinate(query: textField.text?.description ?? "Pizza", location: textField.text ?? "laurelton")
           // print("location search results")
            print("LOCATION JOHNSON ROD \(String(describing: textField.text))")
            resignFirstResponder()
        }
        
        if textField == searchView.venueSearchBar {
            getVenueWOCoordinate(query: textField.text?.description ?? "pizza", location: textField.text ?? "laurelton" )
            print("VENU search results")
           
            
            resignFirstResponder()
        }
        
        if textField == searchView.locationSearch {
            if textField.text == nil {
                textField.text = defaultLocation
            }
        }
    }
    
}
//---------------------------------------------------------------
//MARK: EXTENSIONS

extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let detailVC = DetailViewController()
        guard view.annotation != nil else {return}
        navigationController?.pushViewController(detailVC, animated: true)
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingNewAnnotations{
            mapView.showAnnotations(annotations, animated: false)
        }
        isShowingNewAnnotations = false
    }
}

//---------------------------------------------------------------
//MARK: EXTENSIONS

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text,!searchText.isEmpty else {
            return true
        }
 
        // MARK: ****** FIX THIS ********
        textFieldSelector(textField)
        convertPlaceNameToCoordinate(searchText)
        
        
        return true
    }
    
}


//---------------------------------------------------------------
//MARK: EXTENSIONS

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

extension SearchController: CoreLocationHandlerDelegate {
    func locationUpdated(_ coreLocationHandler: CoreLocationHandler, _ locations: [CLLocation]) {
        if let newLoc = locations.first{
            loadUserLocation(newLoc)
        }
    }
    
    
}
