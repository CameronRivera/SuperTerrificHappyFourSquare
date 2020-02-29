//
//  FourSquareTabBarController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import DataPersistence

struct Collection: Codable & Equatable {
    var name = String()
    var savedCollections = [Venue]()
}

class FourSquareTabBarController: UITabBarController {
    
    //FIXME:
    private var tabBarInstanceOfDataPersistence = DataPersistence<Collection>(filename: "collectionWithVenueDetails.plist")
    
    //VC1:
    private lazy var searchController: SearchController = {
        let viewController = SearchController(tabBarInstanceOfDataPersistence)
//        let viewController = SearchController()
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        //FIXME: I dont think we need to use DataPersistence here at all
        //viewController.dataPersistence = tabBarInstanceOfDataPersistence
        //viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    //VC 2:
    private lazy var allCategoriesController: ShowAllCollectionsController = {
        let viewController = ShowAllCollectionsController(tabBarInstanceOfDataPersistence)
        viewController.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "rectangle.grid.1x2"), tag: 1)
        //FIXME: add datapersistence and/or delegate?
       // viewController.dataPersistence = tabBarInstanceOfDataPersistence
       // viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: searchController), UINavigationController(rootViewController: allCategoriesController)]
    }
    
}



