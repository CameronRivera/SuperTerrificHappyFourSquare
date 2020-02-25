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
    
    var nameOfNewCategory = String()
    
    override func loadView() {
        view = showAllCollectionView
    }
    
    var newCategories = [String]() {
         didSet {
             DispatchQueue.main.async {
                self.showAllCollectionView.collectionView.reloadData()
            }
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: change background color back to .systemGroupedBacground
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "My Collections"
        
        showAllCollectionView.collectionView.dataSource = self
        showAllCollectionView.collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBarButtonItemPressed(_:)))
        
        showAllCollectionView.collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: "customCollectionCell")
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
        
        //STEPS:
        // 1. Array of Strings with Custom Categories
        // 2. Create/load cell and for label give name of new category
        
        let alertController = UIAlertController(title: "Enter Name of New Collection", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let createAction = UIAlertAction(title: "Create", style: .default) {
            [unowned alertController] _ in
            self.nameOfNewCategory = alertController.textFields![0].text?.capitalized ?? "No Name"
            self.newCategories.append(self.nameOfNewCategory)
            print("Created folder with name: \(self.nameOfNewCategory)")
            print("There are following categories: \(self.newCategories)")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(createAction)
        
        //dismissed
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func createNewCategory() {
      
    }
}


extension ShowAllCollectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("could not downcast to CustomCollectionCell")
        }
        let savedCategory = newCategories[indexPath.row]
        cell.configureCategoryCollectionCell(savedCategory)
        //FIXME: remove cell color
        cell.backgroundColor = .systemGroupedBackground
        
        
        //segue to CategoryController
        
        return cell
    }
}

extension ShowAllCollectionsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 20
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpacing: CGFloat = numberOfItems + interItemSpacing + 30
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newCategory = newCategories[indexPath.row]
        let categoryVC = CategoryController()
       //let categoryVC = CategoryController(dataPersistence, article: article)
        navigationController?.pushViewController(categoryVC, animated: true)
    }
}

