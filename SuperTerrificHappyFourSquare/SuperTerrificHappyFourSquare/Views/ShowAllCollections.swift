//
//  ShowAllCollections.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class ShowAllCollections: UIView {
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()

        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super .init(coder: coder)
            commonInit()
        }
        
        private func commonInit(){
            setupLayoutConstraints()
        }
    
    private func setupLayoutConstraints() {
         addSubview(collectionView)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
             collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
         ])
     }


}
