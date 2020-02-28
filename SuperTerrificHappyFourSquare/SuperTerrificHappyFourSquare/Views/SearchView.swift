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
import ImageKit

class SearchView: UIView {
    
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        return mapView
    }()
    
    lazy var eventsListButton: UIButton = {
        let listButton = UIButton()
        listButton.setImage(UIImage(named: "TRIANLE-FLAME"), for: .normal)
        listButton.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        listButton.layer.shadowOpacity = 1
        listButton.layer.shadowRadius = 3.0
        listButton.layer.cornerRadius = 20
        listButton.layer.shadowColor = UIColor.systemPurple.cgColor
        
        return listButton
    }()
    
    lazy var venueSearchBar: UITextField = {
        let venueSearch = UITextField()
        venueSearch.placeholder = "  search"
        venueSearch.backgroundColor = .systemBackground
        venueSearch.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        venueSearch.layer.shadowOpacity = 1
        venueSearch.layer.shadowRadius = 3.0
        venueSearch.layer.cornerRadius = 15
        venueSearch.layer.shadowColor = UIColor.systemGray2.cgColor
        return venueSearch
    }()
    
    lazy var locationSearch: UITextField = {
        let locationSearch = UITextField()
        locationSearch.placeholder = "  New York, NY"
        locationSearch.backgroundColor = .systemBackground
        locationSearch.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        locationSearch.layer.shadowOpacity = 1
        locationSearch.layer.shadowRadius = 3.0
        locationSearch.layer.cornerRadius = 15
        locationSearch.layer.shadowColor = UIColor.systemGray2.cgColor
        
        return locationSearch
    }()
    
    
    
    lazy var venuesCollectionView: UICollectionView = {
        
        let cellLayout = UICollectionViewFlowLayout()
        cellLayout.scrollDirection = .horizontal
        cellLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 1, bottom: 0, right: 1)
        cellLayout.itemSize = CGSize.init(width: 100, height: 100)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cellLayout)
        collectionView.backgroundColor = .systemPink
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
        optionButtonConstraints()
        searchConstraints()
        locationConstraints()
        collectionViewConstraints()
    }
    
    private func mapConstraints() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        // mapView.isHidden = true
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            mapView.heightAnchor.constraint(equalToConstant: 1000)])
    }
    
    
    
    private func searchConstraints() {
        addSubview(venueSearchBar)
        venueSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            venueSearchBar.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 80),
            venueSearchBar.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            venueSearchBar.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            venueSearchBar.heightAnchor.constraint(equalToConstant: 45)])
        
    }
    
    private func optionButtonConstraints(){
        addSubview(eventsListButton)
        eventsListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventsListButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15),
            eventsListButton.leadingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -40),
            eventsListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            eventsListButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        
    }
    
    private func locationConstraints() {
        addSubview(locationSearch)
        locationSearch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationSearch.topAnchor.constraint(equalTo: venueSearchBar.bottomAnchor, constant: 20),
            locationSearch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationSearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            locationSearch.heightAnchor.constraint(equalToConstant: 45)])
    }
    
    
    private func collectionViewConstraints() {
        addSubview(venuesCollectionView)
        venuesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            venuesCollectionView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 1),             venuesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1), venuesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1), venuesCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
