//
//  DetailViewController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private let detailView = DetailView()
    
    private let dummyArray: [String] = ["Clip", "Clop"]
    
    override func loadView(){
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.backgroundColor = .systemBackground
        navigationItem.title = "Detail View"
        setUp()
    }
    
    private func setUp(){
        detailView.collectionView.dataSource = self
        detailView.collectionView.delegate = self
        detailView.collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCell")
    }

}

extension DetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("Could not dequeue cell as a CustomCollectionCell")
        }
        
        xCell.backgroundColor = .systemBackground
        return xCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyArray.count
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.3, height: collectionView.bounds.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
