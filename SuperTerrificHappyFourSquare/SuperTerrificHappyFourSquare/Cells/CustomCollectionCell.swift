//
//  CustomCollectionCell.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

protocol CustomCollectionCellDelegate: AnyObject{
    func addButtonPressed(_ customCollectionCell: CustomCollectionCell)
}

class CustomCollectionCell: UICollectionViewCell {

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 1.0
        return imageView
    }()
    
    public lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.0
        label.textAlignment = .center
        return label
    }()
    
    public lazy var addButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public lazy var tintedView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.backgroundColor = UIColor.black
        return view
    }()
    
    public weak var delegate: CustomCollectionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpImageViewConstraints()
        setUpCategoryLabelConstraints()
        setUpTintedViewConstraints()
        setUpAddButtonConstraints()
    }
    
    private func setUpImageViewConstraints(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor), imageView.leadingAnchor.constraint(equalTo: leadingAnchor), imageView.trailingAnchor.constraint(equalTo: trailingAnchor), imageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func setUpCategoryLabelConstraints(){
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor), categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)])
    }
    
    private func setUpTintedViewConstraints(){
        addSubview(tintedView)
        tintedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tintedView.topAnchor.constraint(equalTo: topAnchor), tintedView.leadingAnchor.constraint(equalTo: leadingAnchor), tintedView.trailingAnchor.constraint(equalTo: trailingAnchor), tintedView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func setUpAddButtonConstraints(){
        tintedView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([addButton.centerYAnchor.constraint(equalTo: centerYAnchor), addButton.centerXAnchor.constraint(equalTo: centerXAnchor), addButton.heightAnchor.constraint(equalToConstant: 50), addButton.widthAnchor.constraint(equalToConstant: 50)])
    }
    
    @objc
    private func addButtonPressed(_ sender: UIButton){
        delegate?.addButtonPressed(self)
    }
    
    // TODO: Add real data into these configure cell methods
    public func configureMKViewCollectionCell(_ model: String){
        DispatchQueue.main.async{
            self.imageView.alpha = 1.0
            self.addButton.alpha = 0.0
            self.tintedView.alpha = 0.0
            self.categoryLabel.alpha = 0.0
        }
        imageView.getImage(with: model) { [weak self] result in
            switch result{
            case .failure:
                break
            case .success(let image):
                DispatchQueue.main.async{
                    self?.imageView.image = image
                }
            }
        }
    }
    
    public func configureCategoryCollectionCell(_ model: String){
        DispatchQueue.main.async{
            self.imageView.alpha = 0.0
            self.addButton.alpha = 0.0
            self.tintedView.alpha = 0.0
            self.categoryLabel.alpha = 1.0
            self.categoryLabel.text = model
        }
    }
    // This function is potentially the same as the one above.
    public func configureAddNewCategoryCell(_ model: String){
        DispatchQueue.main.async{
            self.imageView.alpha = 0.0
            self.addButton.alpha = 1.0
            self.tintedView.alpha = 0.6
            self.categoryLabel.alpha = 1.0
            self.categoryLabel.text = model
        }
    }

}
