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
    private var refreshController: UIRefreshControl!
    
    private var venues: [Venue]
    private var countDown: Int {
        didSet{
            if countDown == 0{
                sleep(1)
                categoryView.tableView.reloadData()
            }
        }
    }
    
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
        configureRefreshControl()
                
    }
    
    init(_ dataPersistence: DataPersistence<Collection>, venues: [Venue]){
        self.dataPersistence = dataPersistence
        self.venues = venues
        self.countDown = venues.count
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureRefreshControl(){
        refreshController = UIRefreshControl()
        categoryView.tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(reloadTableViewData), for: .valueChanged)
    }
    
    @objc
    private func reloadTableViewData(){
        categoryView.tableView.reloadData()
    }
    
}

extension CategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME: addedCategory.count
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("could not downcast to CustomTableViewCell")
        }
        cell.configureTableViewCell(venues[indexPath.row])
        cell.backgroundColor = .systemGroupedBackground
        
        //Used for testing purpose
        //cell.configureTableViewCell("Test")
//        categoryView.tableView.reloadData()
//        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        countDown -= 1
        return cell
    }
}

extension CategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "DetailTableViewController", bundle: nil)
        let detailVC = sb.instantiateViewController(identifier: "DetailTableViewController") { [unowned self] (coder) in
            return DetailTableViewController(coder: coder,self.venues[indexPath.row], self.dataPersistence)
        }
        //let categoryVC = CategoryController(dataPersistence, article: article)
        //navigationController?.pushViewController(detailVC, animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
