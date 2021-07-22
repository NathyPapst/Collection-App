//
//  CreateCollectionViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 22/07/21.
//

import UIKit

struct CollectionStruct {
    var name: String
}

class CreateCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var imageSpace: UIImageView = UIImageView(frame: .zero)
    var cancelButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var coverPhotoLabel: UILabel = UILabel()
    var addPhotoButton: UIButton = UIButton(type: .custom)
    var collection = CollectionStruct(name: "")
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
      table.register(TextField.self, forCellReuseIdentifier: "cell")
      return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Nova Coleção"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelNewCollection))
        navigationItem.leftBarButtonItem = cancelButton!
        
        addButton = UIBarButtonItem(title: "Adicionar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addNewCollection))
        navigationItem.rightBarButtonItem = addButton!
        
        view.addSubview(coverPhotoLabel)
        coverPhotoLabel.text = "Foto de Capa:"
        coverPhotoLabel.textColor = .black
        coverPhotoLabel.font = .systemFont(ofSize: view.frame.height  * 0.028, weight: .regular)

        view.addSubview(imageSpace)
        imageSpace.backgroundColor = #colorLiteral(red: 0.8626788259, green: 0.8627825379, blue: 0.8626434207, alpha: 1)
        imageSpace.layer.cornerRadius = view.frame.width/45

        imageSpace.addSubview(addPhotoButton)
        let configIcon = UIImage.SymbolConfiguration(pointSize: view.frame.height * 0.05, weight: .bold, scale: .large)
        addPhotoButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        addPhotoButton.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        addConstraints()
    }
    
    func addConstraints() {
        imageSpace.translatesAutoresizingMaskIntoConstraints = false
        imageSpace.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5).isActive = true
        imageSpace.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/10).isActive = true
        imageSpace.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/10).isActive = true
        imageSpace.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/1.7).isActive = true
        
        coverPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/20).isActive = true
        coverPhotoLabel.bottomAnchor.constraint(equalTo: imageSpace.topAnchor, constant: -view.frame.height/40).isActive = true
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.centerXAnchor.constraint(equalTo: imageSpace.centerXAnchor).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: imageSpace.centerYAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: imageSpace.bottomAnchor, constant: view.frame.height/30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TextField {
            cell.backgroundColor =  #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
            cell.placeHolder = "Nome"
            cell.dataTextField.delegate = self
            cell.dataTextField.tag = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    
    enum textFieldData: Int {
        case nome = 0
    }
    
    func isTyping(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(newValue), for: .editingChanged)
    }
    
    @objc func newValue(_ textField: UITextField) {
        switch textField.tag {
            case textFieldData.nome.rawValue:
                collection.name = textField.text ?? ""
            default:
                break
        }
    }
    
    @objc func cancelNewCollection() {
        
    }
    
    @objc func addNewCollection() {
        
    }
}
