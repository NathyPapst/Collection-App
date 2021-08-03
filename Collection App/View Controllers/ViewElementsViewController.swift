//
//  ViewElementsViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 26/07/21.
//

import UIKit
import CoreData

class ViewElementsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    var addButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var eraseButton: UIBarButtonItem!
    private var collectionView: UICollectionView?
    
    var collection: Collection
    var items = [Element]()
    
    init(collectionAttributes: Collection) {
        self.collection = collectionAttributes
        super.init(nibName: nil, bundle: nil)
        let elements = (collection.containElements?.allObjects as? [Element])
        items = elements ?? []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = collection.name
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addElement))
        
        editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(editCollection))
        
        eraseButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(eraseCollection))
    
        navigationItem.rightBarButtonItems = [addButton!, editButton!, eraseButton!]
        
        let layout = makeLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
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
    
    func addConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/20).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/20).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionCell
        cell?.collectionPhoto.image = UIImage(data: item.photo ?? Data())
        cell?.collectionLabel.text = item.name
        return cell ?? CollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = items[indexPath.row]
        let vc = ViewAndEditElementViewController(elementAttributes: element)
        vc.editDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addElement() {
        let root = NewElementViewController(collectionAttributes: collection)
        let vc = UINavigationController(rootViewController: root)
        root.elementsDelegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
        
    }
    
    @objc func editCollection() {
        let root = EditCollectionViewController(collectionAttributes: collection)
        let vc = UINavigationController(rootViewController: root)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    @objc func eraseCollection() {
        let alert = UIAlertController(title: "Tem certeza que deseja apagar essa coleção?", message: "Se exclui-la, você perderá todas as informações contidas nela", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Deletar Coleção", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
            _ = try? CoreDataStack.shared.deleteCollection(collection: self.collection)
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelDelete = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancelDelete)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewElementsViewController: CreateAndEditElementsViewControllerDelegate {
    func didRegister() {
        items = []
        items = collection.containElements?.allObjects as? [Element] ?? []
        collectionView?.reloadData()
    }
}
