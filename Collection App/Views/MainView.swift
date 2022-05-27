//
//  MainView.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 27/05/22.
//

import Foundation
import UIKit

class MainView: UIView {
    
    lazy var addButton: UIBarButtonItem = {
        var bt = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addCollection))
        bt.tintColor = UIColor(named: "AccentColor")
        
        return bt
    }()
    
    lazy var collectionSearchBar: UISearchBar = {
        var sb = UISearchBar()
        sb.placeholder = "Buscar"
        sb.searchBarStyle = UISearchBar.Style.minimal
        sb.sizeToFit()
        sb.isTranslucent = false
        
        return sb
    }()
    
    var collectionCollectionView: UICollectionView?
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: "BackgroundColor")
        
        setCollectionView()
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionView() {
        let layout: UICollectionViewCompositionalLayout = makeLayout()
        
        collectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionCollectionView?.backgroundColor = .blue
        collectionCollectionView?.register(CollectionCell.self, forCellWithReuseIdentifier: "Collection")
//        cv.dataSource = self
//        cv.delegate = self
    }
    
    private func addElements() {
        self.addSubview(collectionSearchBar)
        
        if let cv = collectionCollectionView {
            self.addSubview(cv)
        }
       
    }
    
    private func setupConstraints() {
        collectionSearchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionSearchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionSearchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionCollectionView?.topAnchor.constraint(equalTo: collectionSearchBar.bottomAnchor, constant: self.frame.height/4).isActive = true
        collectionCollectionView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionCollectionView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionCollectionView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc func addCollection() {
        
    }
}
