//
//  SearchView.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchView: UIView {
    
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        return mapView
    }()
    
    lazy var venueSearchBar: UITextField = {
        let venueSearch = UITextField()
        venueSearch.placeholder = "search"
        venueSearch.layer.cornerRadius = 10
        return venueSearch
    }()
    
    lazy var userLocationSearch: UITextField = {
        let locationSearch = UITextField()
        locationSearch.placeholder = "New York, NY"
        locationSearch.layer.cornerRadius = 10
        return locationSearch
    }()
    
    lazy var eventsListButton: UIButton = {
        let listButton = UIButton()

        
        //MARK: ***************** SET THE IMAGE FOR THE BUTTTON HERE "TRIANGLE FLAMES" ***********************
        
        return listButton
    }()
    
    lazy var venuesCollectionView: UICollectionView = {
        
        let cellLayout = UICollectionViewFlowLayout()
        cellLayout.scrollDirection = .horizontal
        cellLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 1, bottom: 0, right: 1)
        cellLayout.itemSize = CGSize.init(width: 100, height: 100)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 5.0
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        mapConstraints()
        searchConstraints()
        userLocationConstraints()
        collectionViewConstraints()
    }
    
    private func mapConstraints() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            mapView.heightAnchor.constraint(equalToConstant: 500)])
    }
    
    private func searchConstraints() {
        addSubview(venueSearchBar)
        venueSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            venueSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            venueSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            venueSearchBar.widthAnchor.constraint(equalToConstant: 300),
            venueSearchBar.heightAnchor.constraint(equalToConstant: 45)])
        
    }
    
    private func userLocationConstraints() {
        addSubview(userLocationSearch)
        userLocationSearch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userLocationSearch.topAnchor.constraint(equalTo: venueSearchBar.bottomAnchor, constant: 20),
            userLocationSearch.leadingAnchor.constraint(equalTo: leadingAnchor),
            userLocationSearch.trailingAnchor.constraint(equalTo: trailingAnchor),
            userLocationSearch.heightAnchor.constraint(equalToConstant: 45)])
    }
    
    
    private func collectionViewConstraints() {
        addSubview(venuesCollectionView)
        venuesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            venuesCollectionView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 1),             venuesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1), venuesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1), venuesCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
