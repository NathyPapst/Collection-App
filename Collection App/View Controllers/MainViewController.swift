//
//  ViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 15/07/21.
//

import UIKit

class MainViewController: UIViewController {
    
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = MainView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Minhas Coleções"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        editButton = UIBarButtonItem(title: "Editar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editCollections))
        navigationItem.leftBarButtonItem = editButton!
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addCollection))
        navigationItem.rightBarButtonItem = addButton!
        
    }
    
    @objc func editCollections() {
        
    }
    
    @objc func addCollection() {
        
    }


}

