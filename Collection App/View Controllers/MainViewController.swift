//
//  ViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 15/07/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    private let coreData = CoreDataStack.shared
    
    private lazy var frc: NSFetchedResultsController<Collection> = {
        let fetchRequest: NSFetchRequest<Collection> = Collection.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Collection.name, ascending: false)]

        let frc = NSFetchedResultsController<Collection>(fetchRequest: fetchRequest, managedObjectContext: coreData.mainContext, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self
        return frc
    }()
    
    var collection: Collection?
    let contentView = MainView()
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        
        do {
            try frc.performFetch()
        }

        catch {
            print("Não foi")
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Minhas Coleções"
        navigationItem.rightBarButtonItem = contentView.addButton
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfCollections = frc.fetchedObjects?.count ?? 0
        return numberOfCollections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionCell else {preconditionFailure()}
        
        let object = frc.object(at: indexPath)
        cell.collectionPhoto.image = UIImage(data: object.photo ?? Data())
        cell.collectionLabel.text = object.name
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let newIndexPath = newIndexPath {
                //collectionView?.insertItems(at: [newIndexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                //collectionView?.deleteItems(at: [indexPath])
            }
        default:
            break
        }
        //collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = frc.object(at: indexPath)
        let vc = ViewElementsViewController(collectionAttributes: object)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addCollection() {
        let root = CreateCollectionViewController(collection: collection)
        let vc = UINavigationController(rootViewController: root)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
}

extension MainViewController: CreateAndEditCollectionViewControllerDelegate {
    func didRegister() {
        //collectionView?.reloadData()
    }
}



