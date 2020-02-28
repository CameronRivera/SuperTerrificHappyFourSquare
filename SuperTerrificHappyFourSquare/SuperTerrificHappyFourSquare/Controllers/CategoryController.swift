//
//  CategoryController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import DataPersistence

class CategoryController: UIViewController {
    
    let categoryView = CategoryView()
       
       private var dataPersistence: DataPersistence<Collection>
       
       //var addedVenue: Venue
       
       override func loadView() {
           view = categoryView
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: change background color back to .systemGroupedBacground
       view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "All Items in My Category"
        
        categoryView.tableView.dataSource = self
        categoryView.tableView.delegate = self
        
        categoryView.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "customTableViewCell")
    }
    
   init(_ dataPersistence: DataPersistence<Collection>){
             self.dataPersistence = dataPersistence
             super.init(nibName: nil, bundle: nil)
         }
     
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
}

extension CategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME: addedCategory.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("could not downcast to CustomTableViewCell")
        }
        cell.backgroundColor = .systemGroupedBackground
        
        //Used for testing purpose
        //cell.configureTableViewCell("Test")
        return cell
    }
}

extension CategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(dataPersistence)
        //let categoryVC = CategoryController(dataPersistence, article: article)
        //navigationController?.pushViewController(detailVC, animated: true)
        navigationController?.present(detailVC, animated: true)
    }
}
