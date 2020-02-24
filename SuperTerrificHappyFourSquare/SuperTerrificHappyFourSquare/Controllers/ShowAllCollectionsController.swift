//
//  ShowAllCategoriesController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import DataPersistence

class ShowAllCollectionsController: UIViewController {
    
    let showAllCollectionView = ShowAllCollections()
    
    //private var dataPersistence: DataPersistence<Name>
    
    //var addedCategories: Category
    
    var newCategory = [String]()
    
    override func loadView() {
        view = showAllCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: change background color back to .systemGroupedBacground
        view.backgroundColor = .systemYellow
        navigationItem.title = "My Collections"
        
        showAllCollectionView.collectionView.dataSource = self
        showAllCollectionView.collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBarButtonItemPressed(_:)))
    }
    
//INITIALIZERS FOR DATA PERSISTANCE:
//    init(_ dataPersistence: DataPersistence<Name>, category: Category){
//        self.dataPersistence = dataPersistence
//        self.addedCategory: Category = category
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @objc func addBarButtonItemPressed(_ sender: UIBarButtonItem) {
// HERE I AM TRYING TO WRITE A CODE THAT WILL PRESENT ACTION SHEET + TEXTFIELD TO CREATE A NEW CUSTOM COLLECTION
        
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.addTextField(configurationHandler: {(textField: UITextField?) -> Void in
//            textField?.placeholder = "Enter Name For New Category"
//        })
//
//        let createAction = UIAlertAction(title: "Create", style: .default) {
//            UIAlertAction in
//            self.createNewCategory(newCategory)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        alertController.addAction(createAction)
//
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true)
//
//    }
//
//    private func createNewCategory(_ newCategory: String) {
//            do {
//                //try dataPersistence.createItem(newCategory)
//            } catch {
//                print("error creating newCategory folder: \(error)")
//            }
//        }
    }
}


extension ShowAllCollectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return addedCategories.count
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("could not downcast to CustomCollectionCell")
        }
//        let savedCategory = savedCategories[indexPath.row]
//        cell.configureCell(for: savedCategory)
        //FIXME: remove cell color
        cell.backgroundColor = .yellow
        //segue to detail cell vc
        
        return cell
    }
}

extension ShowAllCollectionsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 20
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpacing: CGFloat = numberOfItems + interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 20
       }
}

