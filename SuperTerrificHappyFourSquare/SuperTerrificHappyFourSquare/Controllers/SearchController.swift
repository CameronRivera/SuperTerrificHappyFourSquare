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
    
    let dataPersistence: DataPersistence<Collection>
    
    private var searchView = SearchView()
    
    var mapView = MKMapView()
    
    private var location = [Location]()
    
    init(_ dataPersistence: DataPersistence<Collection>){
            self.dataPersistence = dataPersistence
            super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    private var venus = [Venue](){
        didSet{
            DispatchQueue.main.async {
                self.loadMap()
               self.searchView.venueCollectionView.reloadData()
            }
        }
    }
    
    private var venuePhoto = [PhotoItems](){
        didSet{
            DispatchQueue.main.async {
               self.searchView.venueCollectionView.reloadData()
            }
        }
    }
    
    
    
    private let locationSession = CoreLocationHandler()
    
    var userTrackingButton: MKUserTrackingButton!
    
    var defaultLocation = "Brooklyn"
    
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
        //loadMap()
        //        getVenueWOCoordinate(query: "", location: "")
        searchView.mapView.delegate = self
        searchView.venueSearchBar.delegate = self
        searchView.locationSearch.delegate = self
        locationSession.delegate = self
        
        searchView.eventsListButton.addTarget(self, action: #selector(listButtonPressed), for: .touchUpInside)
    }
    
    
    
    private func setUp(){
        navigationItem.title = "Search Venues"
        searchView.venueCollectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCollectCell")
        searchView.venueCollectionView.dataSource = self
        searchView.venueCollectionView.delegate = self
        
    }
    
    
    
    private func getVenueWOCoordinate(query: String, location: String){
        
        let _ = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "McDonalds"
        
        let _ = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Queens"
        
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
    
    
    
    
    
    @objc func listButtonPressed(){
        let catVC = CategoryController(dataPersistence, venues: venus)
            
        
        
        self.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(catVC, animated: true)
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
                print(location.name ?? "Mcdonalds")
            }
        }
    }
    
}









//---------------------------------------------------------------
//MARK: EXTENSIONS

extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let mappedArr = venus.map{ $0.name }
        
        if let title = view.annotation?.title ?? "", let venueIndex = mappedArr.firstIndex(of: title) {
        let sb = UIStoryboard(name: "DetailTableViewController", bundle: nil)
        let detailVC = sb.instantiateViewController(identifier: "DetailTableViewController") { [unowned self] (coder) in
            return DetailTableViewController(coder: coder,self.venus[venueIndex], self.dataPersistence)
        }
        guard view.annotation != nil else {return}
        navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        
        let identifier = "annotationView"
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.image = UIImage(named: "alexHeadThumbnail")
        annotationView.canShowCallout = true
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
        
        if textField == searchView.locationSearch {
            getVenueWOCoordinate(query: searchView.venueSearchBar.text ?? "Pizza", location: searchView.locationSearch.text ?? "Brooklyn")
            resignFirstResponder()
        }
        
        if textField == searchView.venueSearchBar {
            getVenueWOCoordinate(query: searchView.venueSearchBar.text ?? "pizza", location: searchView.locationSearch.text ?? "Brooklyn" )
            resignFirstResponder()
        }
        // MARK: ****** FIX THIS ********
        //textFieldSelector(textField)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("could not cast to cell")
        }
        cell.backgroundColor = .systemGroupedBackground
        let venue = venus[indexPath.row]
        cell.configureMKViewCollectionCell(venue)
        
        return cell
    }
    
    
}


extension SearchController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let venu = venus[indexPath.row]
        let sb = UIStoryboard(name: "DetailTableViewController", bundle: nil)
        let detailVC = sb.instantiateViewController(identifier: "DetailTableViewController") { (coder) in
            return DetailTableViewController(coder: coder, venu, self.dataPersistence)
        }
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
