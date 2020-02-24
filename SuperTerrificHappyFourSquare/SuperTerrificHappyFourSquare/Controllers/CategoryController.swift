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
       
       // private var dataPersistence: DataPersistence<Name>
       
       //var addedCategory: Category
       
       override func loadView() {
           view = categoryView
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: change background color back to .systemGroupedBacground
       view.backgroundColor = .systemGreen
        navigationItem.title = "All Items in My Category"
        
        categoryView.tableView.dataSource = self
        categoryView.tableView.delegate = self
    }
    
    //    init(_ dataPersistence: DataPersistence<Name>, category: Category){
    //        self.dataPersistence = dataPersistence
    //        self.addedCategory: Category = category
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
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
        return cell
    }
}

extension CategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
