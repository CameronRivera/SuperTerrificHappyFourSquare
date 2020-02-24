//
//  FourSquareTabBarController.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import DataPersistence

class FourSquareTabBarController: UITabBarController {
    
    //FIXME:
    //private var dataPersistence = DataPersistence<NAME>(filename: "NAME.plist")
    
    //VC1:
    private lazy var searchController: SearchController = {
        let viewController = SearchController()
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        //FIXME: add datapersistence and/or delegate?
        //viewController.dataPersistence = dataPersistence
        //viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    //VC 2:
    private lazy var categoryController: CategoryController = {
        let viewController = CategoryController()
        viewController.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "rectangle.grid.1x2"), tag: 1)
        //FIXME: add datapersistence and/or delegate?
        //viewController.dataPersistence = dataPersistence
        //viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: searchController), UINavigationController(rootViewController: categoryController)]
    }
    
}



