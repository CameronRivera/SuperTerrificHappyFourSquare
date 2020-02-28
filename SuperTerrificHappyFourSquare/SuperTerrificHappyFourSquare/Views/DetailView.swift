//
//  DetailView.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit

class DetailView: UIView {
    
    public lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Subject to change
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray4
        return cv
    }()
    
    public lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    public lazy var venueNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Venue Name Label"
        return label
    }()
    
    public lazy var venueAddressLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Venue Address"
        return label
    }()
    
    // TODO: Perhaps this is not good as a label, maybe multiple labels, or even a table view...?
    public lazy var hoursOfOperationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Hours of operations"
        return label
    }()
    
    public lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public lazy var mapView: MKMapView = {
       let mv = MKMapView()
        return mv
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.brown
        return scrollView
    }()
    
    public lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBlue
        return contentView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        // setUpCollectionViewConstraints()
        setUpImageViewConstraints()
        setUpMapViewConstraints()
        setUpScrollViewConstraints()
        setUpContentViewConstraints()
        setUpStackViewConstraints()
    }
    
    private func setUpCollectionViewConstraints(){
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20), collectionView.leadingAnchor.constraint(equalTo: leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: trailingAnchor), collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)])
    }
    
    private func setUpImageViewConstraints(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20), imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20), imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20), imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.29)])
    }
    
    private func setUpStackViewConstraints(){
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(venueNameLabel)
        stackView.addArrangedSubview(hoursOfOperationLabel)
        stackView.addArrangedSubview(venueAddressLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20), stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8), stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8), scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    private func setUpMapViewConstraints(){
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8), mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)])
    }
    
    private func setUpScrollViewConstraints(){
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20), scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20), scrollView.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -8)])
    }
    
    private func setUpContentViewConstraints(){
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([ contentView.heightAnchor.constraint(equalTo: heightAnchor), contentView.widthAnchor.constraint(equalTo: widthAnchor)])
    }

}

/*
 scrollView.topAnchor.constraint(equalTo: scrollView.topAnchor), contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor), contentView.trailingAnchor.constraint(equalTo: trailingAnchor), contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
 */
