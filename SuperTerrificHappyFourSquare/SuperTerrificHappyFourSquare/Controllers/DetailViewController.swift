//
//  DetailViewController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit
import DataPersistence

class DetailViewController: UIViewController {

    private let detailView = DetailView()
    private let coreLocationManager = CoreLocationHandler()
    private var venueAnnotation: MKPointAnnotation = MKPointAnnotation()
    // Model Data Variable, for the annotation
   // private var venueInformation: VenueInfo
    
    
    private var dataPersistence: DataPersistence<Collection>
    //FIXME: We need to add persistance from detail VC to ShowAllCollectionsVC
    //detailVC.dataPersistance = dataPersistance
    // DP Step 8. Setting up data persistance
//     @objc
//     func saveArticleButtonPressed(_ sender: UIBarButtonItem){
//         //print("saved article button pressed")
//         guard let article = article else { return }
//         do {
//             //SAVING TO DOCUMENT DIRECTORY
//             try dataPersistance.createItem(article)
//         } catch {
//             print("error saving article: \(error)")
//         }
//     }
    
    // Dummy data for the collection view.
 //   private let dummyArray: [String] = ["Clip", "Clop"]
    
    override func loadView(){
        view = detailView
    }
    
        init(_ dataPersistence: DataPersistence<Collection>){
            self.dataPersistence = dataPersistence
            super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    // Requires a CLLocationCoordinate2D, and a DetailedVenueInfo Model.
//    init(_ venue: VenueInfo){
//        venueInformation = venue
//        super.init(nibName: nil,bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("Init(coder:) was not implemented.")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.backgroundColor = .systemBackground
        navigationItem.title = "Detail View"
        setUp()
    }
    
    private func setUp(){
//        detailView.collectionView.dataSource = self
//        detailView.collectionView.delegate = self
//        detailView.collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCell")
        detailView.scrollView.contentSize = detailView.contentView.frame.size
        detailView.mapView.delegate = self
        // Get some location here, or pass in some location
        makeAnnotations()
        showAnnotations()
        
    }
    
    private func makeAnnotations() {
        let annotation = MKPointAnnotation()
        annotation.title = "Central Park"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.967544)
        venueAnnotation = annotation
    }
    
    private func showAnnotations() {        detailView.mapView.addAnnotation(venueAnnotation)
        //detailView.mapView.showAnnotations([venueAnnotation], animated: true)
        let region = MKCoordinateRegion(center: venueAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        detailView.mapView.setRegion(region, animated: true)
    }

}

// If we decide not to use a collectionView because there are not enough photos, we can just ignore this code.

//extension DetailViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCollectionCell else {
//            fatalError("Could not dequeue cell as a CustomCollectionCell")
//        }
//
//        xCell.backgroundColor = .systemBackground
//        return xCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       // return dummyArray.count
//        return 0
//    }
//}
//
//extension DetailViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width * 0.3, height: collectionView.bounds.height * 0.8)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//}

extension DetailViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Maybe segue to a safariViewController with the website...?
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
            // annotationView?.glyphImage
            // annotationView?.glyphTintColor
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
}
