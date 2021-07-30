//
//  CollectionCell.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 30/07/21.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    var collectionLabel: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 18.0)
        return name
    }()
    
    var collectionPhoto: UIImageView = {
        let photo = UIImageView()
        return photo
    }()
    
    var collectionLabelBackground: UILabel = {
        let background = UILabel()
        background.backgroundColor = .white
        background.text = " "
        background.font = UIFont.boldSystemFont(ofSize: 20.0)
        return background
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionLabel)
        self.addSubview(collectionPhoto)
        self.addSubview(collectionLabelBackground)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width/45
        
        collectionPhoto.layer.cornerRadius = self.frame.width/45
        
        collectionPhoto.translatesAutoresizingMaskIntoConstraints = false
        collectionPhoto.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionPhoto.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionPhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionPhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        collectionLabelBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionLabelBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionLabelBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionLabel.centerYAnchor.constraint(equalTo: collectionLabelBackground.centerYAnchor).isActive = true
        collectionLabel.leadingAnchor.constraint(equalTo: collectionLabelBackground.leadingAnchor, constant: 5).isActive = true
        collectionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
