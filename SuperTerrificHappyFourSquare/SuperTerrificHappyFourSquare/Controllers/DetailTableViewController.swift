//
//  DetailTableViewController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/27/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit
import ImageKit
import DataPersistence
import SafariServices

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var operationStatusLabel: UILabel!
    @IBOutlet weak var untilTimeLabel: UILabel!
    @IBOutlet weak var categoriesAndPriceLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateAndPostalCodeLabel: UILabel!
    
    private let coreLocationManager = CoreLocationHandler()
    private var venueAnnotation: MKPointAnnotation = MKPointAnnotation()
    private let dataPersistence: DataPersistence<Collection>
    
    private var currentVenue: ExtendedVenueInfo?{
        didSet{
            DispatchQueue.main.async{
                self.setUpStepTwo()
            }
        }
    }
    
    private let operationQueue = OperationQueue()
    private let details: Venue
    
    init?(coder: NSCoder, _ venue: Venue, _ dataPersistence: DataPersistence<Collection>){
        details = venue
        self.dataPersistence = dataPersistence
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstOperation = BlockOperation{
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            self.setUpStepOne(dispatchGroup)
            dispatchGroup.wait()
        }
        
        let secondOperation = BlockOperation{
            DispatchQueue.main.async{
                self.setUpStepTwo()
            }
        }
        
        secondOperation.addDependency(firstOperation)
        operationQueue.addOperation(firstOperation)
        operationQueue.addOperation(secondOperation)
    }
    
    private func setUpStepOne(_ group: DispatchGroup){
        FourSquareAPIClient.getVenueDetails(venueID: details.id) { [weak self] (result) in
            switch result{
            case .failure(let appError):
                print("There was an error loading venue details: \(appError)")
                group.leave()
            case .success(let exVenueInfo):
                self?.currentVenue = exVenueInfo
                group.leave()
            }
        }
    }
    
    private func setUpStepTwo(){
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(favouritedButtonPressed(_:))
        configureVenueImage()
        configureOperationStatusLabels()
        configureAddressLabel()
        configureCategoriesAndPriceLabel()
        configureMapView()
        configureContactInformation()
        mapView.delegate = self
    }
    
    private func configureVenueImage(){
        if let firstPhoto = currentVenue?.response.venue.bestPhoto {
            venueImageView.getImage(with: "\(firstPhoto.prefix)500\(firstPhoto.suffix)") { [weak self] (result) in
                switch result{
                case .failure(let appError):
                    print("There was an error loading the photo: \(appError)")
                case .success(let image):
                    DispatchQueue.main.async{
                        self?.venueImageView.image = image
                    }
                }
            }
        } else {
            DispatchQueue.main.async{
                self.venueImageView.image = UIImage(systemName: "TRIANLE-FLAME")
            }
        }
    }
    
    private func configureOperationStatusLabels(){
        guard let currentVenue = currentVenue else {
            print("Failed to properly pass data.")
            return
        }
        
        if let isOpen = currentVenue.response.venue.popular?.isOpen {
            if !isOpen{
                DispatchQueue.main.async{
                    self.operationStatusLabel.textColor = UIColor.systemRed
                    self.operationStatusLabel.text = "Closed"
                }
            } else {
                DispatchQueue.main.async{
                    self.operationStatusLabel.textColor = UIColor.systemGreen
                    self.operationStatusLabel.text = "Open"
                }
            }
        } else {
            DispatchQueue.main.async{
                self.operationStatusLabel.text = ""
                self.untilTimeLabel.text = "Hours: unknown"
            }
        }
        
        untilTimeLabel.text = currentVenue.response.venue.hours?.status
    }
    
    private func configureAddressLabel(){
        guard let currentVenue = currentVenue else {
            print("Could not successfully pass data.")
            return
        }
        DispatchQueue.main.async{
            self.addressLabel.text = currentVenue.response.venue.location.address
            self.stateAndPostalCodeLabel.text = "\(currentVenue.response.venue.location.city), \(currentVenue.response.venue.location.state), \(currentVenue.response.venue.location.postalCode)"
        }
    }
    
    private func configureCategoriesAndPriceLabel() {
        guard let currentVenue = currentVenue else {
            print("Failed to properly pass data.")
            return
        }
        navigationItem.title = currentVenue.response.venue.name
        if let price = currentVenue.response.venue.attributes?.groups.filter({ $0.type.lowercased() == "price"}).first?.summary {
            DispatchQueue.main.async{
                self.categoriesAndPriceLabel.text = "\(price)"
            }
        } else  {
            DispatchQueue.main.async{
                self.categoriesAndPriceLabel.text = "N/A"
            }
        }
        
        if let categories = currentVenue.response.venue.categories?.reduce("", { (result, cats) -> String in
            if result != ""{
            return  result + ", " + cats.pluralName
            } else {
                return result + cats.pluralName
            }
        }){
            DispatchQueue.main.async{
                self.categoriesAndPriceLabel.text! += "- \(categories)"
            }
        } else {
            DispatchQueue.main.async{
                self.categoriesAndPriceLabel.text! += "- No categories found"
            }
        }
    }
    
    private func configureMapView() {
        makeAnnotations()
        showAnnotations()
    }
    
    private func configureContactInformation(){
        guard let currentVenue = currentVenue else {
            print("Did not successfully pass data.")
            return
        }
        if let phoneNumber = currentVenue.response.venue.contact.formattedPhone {
            DispatchQueue.main.async{
                self.phoneNumberLabel.text = "Phone: \(phoneNumber)"
            }
        } else {
            DispatchQueue.main.async{
                self.phoneNumberLabel.text = "No phone number available"
            }
        }
        
        if let url = currentVenue.response.venue.url {
            DispatchQueue.main.async{
                self.websiteLabel.text = "Website: \(url) "
            }
        } else if let canUrl = currentVenue.response.venue.canonicalUrl{
            DispatchQueue.main.async{
                self.websiteLabel.text = "Website: \(canUrl)"
            }
        }
    }

    private func makeAnnotations() {
        guard let currentVenue = currentVenue else {
            print("Data was not properly passed.")
            return
        }
        let annotation = MKPointAnnotation()
        annotation.title = currentVenue.response.venue.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: currentVenue.response.venue.location.lat, longitude: currentVenue.response.venue.location.lng)
        venueAnnotation = annotation
    }
    
    private func showAnnotations() {
        mapView.addAnnotation(venueAnnotation)
        let region = MKCoordinateRegion(center: venueAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func directionsButtonPressed(_ sender: UIButton){
        guard let currentVenue = currentVenue else {
            print("Did not properly pass data")
            return
        }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentVenue.response.venue.location.lat - 1, longitude: currentVenue.response.venue.location.lng - 1), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentVenue.response.venue.location.lat, longitude: currentVenue.response.venue.location.lng), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] (response, error) in
            if let error = error {
                print("Encountered Error while calculating directions: \(error)")
            }
            
            guard let response = response else {
                return
            }
            
            for route in response.routes {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    @objc
    private func favouritedButtonPressed(_ sender: UIBarButtonItem){
        // TODO: Remove dataPersistence from everywhere except the collectionViewController.
        // Show an alert, that allows the user to select an option.
        // Make an initializer with an optional venue.
        // Make an enumeration to distinguish whether we are creating a new collection, or writing to an existing one.
        // Create a new viewController to present when the favourites button is pressed.
        let favouriteVC = FavouriteOptionsViewController(dataPersistence, self.tabBarController!, details)
        favouriteVC.modalPresentationStyle = .currentContext
        present(favouriteVC, animated: true, completion: nil)
    }
}

extension DetailTableViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // currentVenue.url
        if let fakeURL = currentVenue?.response.venue.url, let url = URL(string:fakeURL){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        } else if let fakeURL = currentVenue?.response.venue.canonicalUrl, let url = URL(string:fakeURL){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Venue Annotation"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.image = UIImage(named: "alexHeadThumbnail")
        
            annotationView.canShowCallout = true
       
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.systemBlue
        return renderer
    }
}


