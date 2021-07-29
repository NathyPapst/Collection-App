//
//  ViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 15/07/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var addButton: UIBarButtonItem!
    private var collectionView: UICollectionView?
    
    private let coreData = CoreDataStack.shared
    private lazy var frc: NSFetchedResultsController<Collection> = {
        let fetchRequest: NSFetchRequest<Collection> = Collection.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Collection.name, ascending: false)]
        
        let frc = NSFetchedResultsController<Collection>(fetchRequest: fetchRequest, managedObjectContext: coreData.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Minhas Coleções"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addCollection))
        navigationItem.rightBarButtonItem = addButton!
        
        let layout = makeLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        do {
            try frc.performFetch()
        }
        
        catch {
            print("Não foi")
        }
        
        view.addSubview(collectionView)
        addConstraints()
        
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .systemBlue
        cell.contentView.layer.cornerRadius = view.frame.width/45
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewElementsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/20).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/20).isActive = true
    }
    
    @objc func addCollection() {
        let root = CreateCollectionViewController()
        let vc = UINavigationController(rootViewController: root)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
}




