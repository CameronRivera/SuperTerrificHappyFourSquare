//
//  DetailView.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit

class FavouriteOptionsView: UIView {
    
    public lazy var tintedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.6
        return view
    }()
    
    public lazy var centerView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    public lazy var addToExistingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Add to Existing", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .systemBackground
        return button
    }()
    
    public lazy var createNewCollectionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Create New Collection", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .systemBackground
        return button
    }()

    public lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .systemBackground
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpTintedViewConstraints()
        setUpCenterViewConstraints()
        setUpStackViewConstraints()
    }

    private func setUpTintedViewConstraints(){
        addSubview(tintedView)
        tintedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tintedView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), tintedView.leadingAnchor.constraint(equalTo: leadingAnchor), tintedView.trailingAnchor.constraint(equalTo: trailingAnchor), tintedView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setUpCenterViewConstraints(){
        tintedView.addSubview(centerView)
        centerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerView.centerYAnchor.constraint(equalTo: centerYAnchor), centerView.centerXAnchor.constraint(equalTo: centerXAnchor), centerView.heightAnchor.constraint(equalToConstant: 200), centerView.widthAnchor.constraint(equalToConstant: 200)])
    }
    
    private func setUpStackViewConstraints(){
        centerView.addSubview(stackView)
        stackView.addArrangedSubview(addToExistingButton)
        stackView.addArrangedSubview(createNewCollectionButton)
        stackView.addArrangedSubview(cancelButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: centerView.topAnchor), stackView.leadingAnchor.constraint(equalTo: centerView.leadingAnchor), stackView.trailingAnchor.constraint(equalTo: centerView.trailingAnchor), stackView.bottomAnchor.constraint(equalTo: centerView.bottomAnchor)])
    }

}
