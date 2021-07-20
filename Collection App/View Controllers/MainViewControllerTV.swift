//
//  MainViewControllerTV.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 20/07/21.
//

import UIKit

class MainViewControllerTV: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var okButton: UIBarButtonItem!
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = MainViewTV()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor =  #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Minhas Coleções"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        okButton = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backToCollections))
        navigationItem.leftBarButtonItem = okButton!
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World: \(indexPath.row+1)"
        cell.textLabel?.textColor = .black
        cell.imageView?.image = UIImage(systemName: "house")
        cell.imageView?.tintColor = .systemGreen
        cell.backgroundColor =  #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    @objc func backToCollections() {
        
    }
}
