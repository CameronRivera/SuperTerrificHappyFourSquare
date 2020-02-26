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

class SearchController: UIViewController {
    
    
    
    private let searchView = SearchView()
    
    
    private var venu = [Venue]() {
        didSet {
            DispatchQueue.main.async {
                self.loadMap()
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
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.backgroundColor = .systemBackground
        loadMap()
       
    }
    
    
    
    @objc func listButtonPressed(){
        let cv = CategoryController()
        self.modalPresentationStyle = .fullScreen
        present(cv, animated: true)
    }
    
    
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in venu {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            //annotation.coordinate = 
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
    }
    
    
    
    func loadMap() {
        let annotations = makeAnnotations()
        searchView.mapView.addAnnotations(annotations)
        searchView.mapView.showAnnotations(annotations, animated: true)
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


//---------------------------------------------------------------
//MARK: EXTENSIONS

extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {return}
        
        let searchQuery = ""
        
        let location = ""
        
        
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

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = textField.text,!searchText.isEmpty else {
            return true
        }
        
        return true
    }
}
