//
//  CustomTableViewCell.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 2/21/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import ImageKit

class CustomTableViewCell: UITableViewCell {
    
//    public lazy var venueImage: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//
//    public lazy var venueName: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        return label
//    }()
//
//    public lazy var additionalInfoLabel: UILabel = {
//       let label = UILabel()
//        label.textAlignment = .left
//        return label
//    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        //commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }
    
//    private func commonInit(){
//          setUpVenueImageConstraints()
//            setUpVenueNameConstraints()
//            setUpAdditionalInfoConstraints()
//    }
//
//    private func setUpVenueImageConstraints(){
//        addSubview(venueImage)
//        venueImage.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([venueImage.topAnchor.constraint(equalTo: topAnchor, constant: 8), venueImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), venueImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8), venueImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)])
//    }
//
//    private func setUpVenueNameConstraints(){
//        addSubview(venueName)
//        venueName.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([venueName.topAnchor.constraint(equalTo: topAnchor, constant: 8), venueName.leadingAnchor.constraint(equalTo: venueImage.trailingAnchor, constant: 8), venueName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), venueName.bottomAnchor.constraint(equalTo: additionalInfoLabel.topAnchor, constant: 8)])
//    }
//
//    private func setUpAdditionalInfoConstraints(){
//        addSubview(additionalInfoLabel)
//        additionalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([additionalInfoLabel.topAnchor.constraint(equalTo: venueName.bottomAnchor, constant: -8), additionalInfoLabel.leadingAnchor.constraint(equalTo: venueImage.trailingAnchor, constant: 8), additionalInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), additionalInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
//    }
    
    public func configureTableViewCell(_ model: Venue){
        // TODO: Replace put in actual model data
        FourSquareAPIClient.getVenuePhotos(venueID: model.id) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting image: \(error)")
            case .success(let photo):
               
               DispatchQueue.main.async {
                let prefix = photo.first?.prefix ?? ""
                let suffix = photo.first?.suffix ?? ""
                 let imageURL = "\(prefix)original\(suffix)"
                self?.imageView?.getImage(with: imageURL) { [weak self] result in
                    switch result{
                    case .failure(let appError):
                        print("this is the error we are looking for \(appError)")
                    case .success(let image):
                        DispatchQueue.main.async{
                            self?.imageView?.image = image
                        }
                    }
                }
            }
            
        }
        }
//        imageView?.getImage(with: model, completion: { [weak self] result in
//            switch result{
//            case .failure:
//                break
//            case .success(let image):
//                DispatchQueue.main.async{
//                    self?.imageView?.image = image
//                }
//            }
//        })
        textLabel?.text = model.name
//        detailTextLabel?.text = model.
    }

}
