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

class FavouriteOptionsViewController: UIViewController {
    
    private let favouriteOptionsView = FavouriteOptionsView()
    private let coreLocationManager = CoreLocationHandler()
    private var venueAnnotation: MKPointAnnotation = MKPointAnnotation()
    private var tabBarCont: UITabBarController
    private var currentVenue: Venue
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
        view = favouriteOptionsView
    }
    // TODO: Refactor to take a venue.
    init(_ dataPersistence: DataPersistence<Collection>, _ tabBar: UITabBarController, _ venue: Venue){
        self.dataPersistence = dataPersistence
        tabBarCont = tabBar
        currentVenue = venue
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
        favouriteOptionsView.backgroundColor = .clear
        setUp()
    }
    
    private func setUp(){
        favouriteOptionsView.createNewCollectionButton.addTarget(self, action: #selector(createButtonPressed(_:)), for: .touchUpInside)
        favouriteOptionsView.addToExistingButton.addTarget(self, action: #selector(existingButtonPressed(_:)), for: .touchUpInside)
        favouriteOptionsView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc
    private func existingButtonPressed(_ sender: UIButton){
        CurrentCollectionState.shared.updateCurrentState(CollectionState.existing)
        CurrentCollectionState.shared.updateCurrentVenue(currentVenue)
        tabBarCont.selectedIndex = 1
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func createButtonPressed(_ sender: UIButton){
        CurrentCollectionState.shared.updateCurrentState(CollectionState.create)
        CurrentCollectionState.shared.updateCurrentVenue(currentVenue)
        tabBarCont.selectedIndex = 1
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancelButtonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }


}

