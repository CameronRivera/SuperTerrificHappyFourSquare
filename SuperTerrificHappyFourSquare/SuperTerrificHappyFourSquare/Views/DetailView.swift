//
//  DetailView.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

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
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpCollectionViewConstraints()
        setUpImageViewConstraints()
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
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20), imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.18), imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)])
    }
    
    private func setUpStackViewConstraints(){
        addSubview(stackView)
        stackView.addArrangedSubview(venueNameLabel)
        stackView.addArrangedSubview(hoursOfOperationLabel)
        stackView.addArrangedSubview(venueAddressLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20), stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20), stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.17)])
    }

}
