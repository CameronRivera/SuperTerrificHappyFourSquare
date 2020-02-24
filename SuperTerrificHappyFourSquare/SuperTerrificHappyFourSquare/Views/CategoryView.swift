//
//  CategoryView.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class CategoryView: UIView {

   public lazy var tableView: UITableView = {
        let tv = UITableView()
       // tv.backgroundColor = .systemGreen
        return tv
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
            setupTableViewConstraints()
        }
    
    private func setupTableViewConstraints() {
         addSubview(tableView)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
             tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
         ])
     }

}
