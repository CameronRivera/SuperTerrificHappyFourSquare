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
    
    private var currentVenue: ExtendedVenueInfo?{
        didSet{
            DispatchQueue.main.async{
                self.setUp()
            }
        }
    }
    
//    init(_ venue: ExtendedVenueInfo){
//        currentVenue = venue
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FourSquareAPIClient.getVenueDetails(venueID: "54b8377e498e68ed33de10cc") { [weak self] (result) in
            switch result{
            case .failure(let appError):
                print("There was an error loading venue details: \(appError)")
            case .success(let exVenueInfo):
                self?.currentVenue = exVenueInfo
            }
        }
    }
    
    private func setUp(){
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
            fatalError("Failed to properly pass data.")
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
            fatalError("Could not successfully pass data.")
        }
        DispatchQueue.main.async{
            self.addressLabel.text = currentVenue.response.venue.location.address
            self.stateAndPostalCodeLabel.text = "\(currentVenue.response.venue.location.city), \(currentVenue.response.venue.location.state), \(currentVenue.response.venue.location.postalCode)"
        }
    }
    
    private func configureCategoriesAndPriceLabel() {
        guard let currentVenue = currentVenue else {
            fatalError("Failed to properly pass data.")
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
            fatalError("Did not successfully pass data.")
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
            fatalError("Data was not properly passed.")
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
            fatalError("Did not properly pass data")
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
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            // Text for the glpyh. If we use this, the image will not show up.
            // annotationView?.glyphText = ""
            
            // An image for the annotation. If we use this, we cannot use text. The tint colour can be used to change the colour of the image.
            // annotationView?.glyphImage = UIImage(named: "alexHead")
            // annotationView?.glyphTintColor
        } else {
            annotationView?.annotation = annotation
        }
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


