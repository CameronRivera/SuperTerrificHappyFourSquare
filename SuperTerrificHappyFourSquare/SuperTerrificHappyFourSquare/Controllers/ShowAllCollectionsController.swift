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
    
    private var dataPersistence: DataPersistence<Collection>
    private var indexToAdd = -1
    
    //FIXME:
//    DELEGATE (who listens) just here!
//    extension SavedArticleViewController: DataPersistenceDelegate {
//        func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
//            print("item was saved")
//        }
//        func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
//            print("item was deleted")
//        }
//    }
    
//    private var savedArticles = [Article]() {
//           didSet {
//               print("there are \(savedArticles.count) articles")
//           }
//       }
    
//          // DP Step 13. Call the function
//            //fetchSavedArticles()
//        }
//
//        // DP Step 12. Conforming to the DataPersistanceDelegate
//        private func fetchSavedArticles(){
//            do {
//                savedArticles = try dataPersistance.loadItems()
//            } catch {
//                print("error fetching articles: \(error)")
//            }
//        }
//    }
    
    //var addedCategories: Category
    
    private var nameOfNewCategory = String()
    private var showAll = [Collection](){
        didSet {
            DispatchQueue.main.async {
                self.showAllCollectionView.collectionView.reloadData()
                self.setUpTab()
            }
        }
    }
    
    override func loadView() {
        view = showAllCollectionView
    }
    
    //INITIALIZERS FOR DATA PERSISTANCE:
    init(_ dataPersistence: DataPersistence<Collection>){
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //Do I need it here? PROBABLY YES, unless I can call it somewhere else
        //showAllCollectionView.collectionView.de

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAllCollectionView.collectionView.reloadData()
        switch CurrentCollectionState.shared.getCurrentState(){
        case .create:
            print("Created")
            addBarButtonItemPressed(navigationItem.rightBarButtonItem!)
        case .existing:
            print("Existing")
        case .tab:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CurrentCollectionState.shared.updateCurrentState(CollectionState.tab)
    }
    
    @objc func addBarButtonItemPressed(_ sender: UIBarButtonItem) {
        // HERE I AM TRYING TO WRITE A CODE THAT WILL PRESENT ACTION SHEET + TEXTFIELD TO CREATE A NEW CUSTOM COLLECTION
        
        //STEPS:
        // 1. Array of Strings with Custom Categories
        // 2. Create/load cell and for label give name of new category
        
        let alertController = UIAlertController(title: "Enter Name of New Collection", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields![0].autocapitalizationType = .words
        
        let createAction = UIAlertAction(title: "Create", style: .default) {
            [unowned alertController, self] _ in
            self.nameOfNewCategory = alertController.textFields![0].text?.capitalized ?? "No Name"
            var newCollection = Collection(name: self.nameOfNewCategory, savedCollections: [])
            if let venue = CurrentCollectionState.shared.getCurrentVenue(){
                newCollection.savedCollections.append(venue)
                CurrentCollectionState.shared.updateCurrentVenue(nil)
            }
            self.showAll.append(newCollection)

            print("Created folder with name: \(self.nameOfNewCategory)")
            //print("There are following categories: \(self.newCategories)")
            // Persist using data Persistence
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(createAction)
        
        //dismissed
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func setUpTab(){
        if showAll.isEmpty{
            showAllCollectionView.collectionView.backgroundView = EmptyStateView(title: "Empty", message: "There are currently no venues in your favourites. Navigate to the search tab to find some venues.")
        } else {
            showAllCollectionView.collectionView.backgroundView = nil
        }
    }
    
    
    private func addNewButtonPressed(index: Int){
        
        if let venue = CurrentCollectionState.shared.getCurrentVenue() {
            showAll[index].savedCollections.append(venue)
        }
        CurrentCollectionState.shared.updateCurrentVenue(nil)
        CurrentCollectionState.shared.updateCurrentState(CollectionState.tab)
        showAllCollectionView.collectionView.reloadData()
        showAlert(title: "Success", message: "Added item to collection \(showAll[index].name).")
    }
    
    //    @objc func addBarButtonItemPressed(_ sender: UIBarButtonItem) {
    //           // HERE I AM TRYING TO WRITE A CODE THAT WILL PRESENT ACTION SHEET + WITH OPTION TO DELETE CREATED CUSTOM COLLECTION
    //
    //           //STEPS:
    //           // 1. Array of Strings with Custom Categories
    //           // 2. Create/load cell and for label give name of new category
    //
    //           let alertController = UIAlertController(title: "Enter Name of New Collection", message: nil, preferredStyle: .alert)
    //           alertController.addTextField()
    //           alertController.textFields![0].autocapitalizationType = .words
    //
    //           let createAction = UIAlertAction(title: "Create", style: .default) {
    //               [unowned alertController] _ in
    //               self.nameOfNewCategory = alertController.textFields![0].text?.capitalized ?? "No Name"
    //               self.newCategories.append(self.nameOfNewCategory)
    //               print("Created folder with name: \(self.nameOfNewCategory)")
    //               print("There are following categories: \(self.newCategories)")
    //           }
    //           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    //
    //           alertController.addAction(createAction)
    //
    //           //dismissed
    //           alertController.addAction(cancelAction)
    //
    //           present(alertController, animated: true)
    //       }
    
    //    private func createNewCategory() {
    //
    //    }
}


extension ShowAllCollectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showAll.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as? CustomCollectionCell else {
            fatalError("could not downcast to CustomCollectionCell")
        }
        
        if CurrentCollectionState.shared.getCurrentState() == .existing{
            cell.configureAddNewCategoryCell(showAll[indexPath.row])
        } else {
            let savedCategory = showAll[indexPath.row]
            cell.configureCategoryCollectionCell(savedCategory)
            //FIXME: remove cell color
            cell.backgroundColor = .systemGroupedBackground
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 30
        }
        cell.delegate = self
        
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
        // let newCategory = newCategories[indexPath.row]
        if let _ = CurrentCollectionState.shared.getCurrentVenue(){
            addNewButtonPressed(index: indexPath.row)
        } else {
        let categoryVC = CategoryController(dataPersistence, venues: showAll[indexPath.row].savedCollections)
        //let categoryVC = CategoryController(dataPersistence, article: article)
        navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
}


extension ShowAllCollectionsController: CustomCollectionCellDelegate {
    func addButtonPressed(_ customCollectionCell: CustomCollectionCell) {
        print("addButtonWasPressed")
    }
    
    func deleteCollectionButtonPressed(_ customCollectionCell: CustomCollectionCell) {
        guard let index = showAllCollectionView.collectionView.indexPath(for: customCollectionCell) else {
            return
        }
        print("didSelectDeleteCollectionPressed")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete This Collection", style: .destructive) {
            UIAlertAction in
            //self.deleteCollection(card)
            //self.newCategories.append(self.nameOfNewCategory)
            self.deleteCollection(self.showAll, index.row)
            print("Deleted collection with name: \(self.nameOfNewCategory)")
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
    
    private func deleteCollection(_ collectionCategory: [Collection], _ index: Int) {
//        guard let index = savedCards.firstIndex(of: card) else {
//            return
//        }
//        do {
//            try dataPersistence.deleteItem(at: index)
//        } catch {
//            print("error deleting card: \(error)")
//        }
        showAll[index].savedCollections.removeAll()
        showAll.remove(at: index)
    }
}







