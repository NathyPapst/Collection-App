//
//  NewElementViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 23/07/21.
//

import UIKit

struct ElementStruct {
    var name: String
    var date: String
    var place: String
    var price: String
}

class NewElementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var cancelButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var coverPhotoLabel: UILabel = UILabel()
    var imageSpace: UIImageView = UIImageView(frame: .zero)
    var addPhotoButton: UIButton = UIButton(type: .custom)
    var notesTextView: UITextView = UITextView()
    var placeholders: [String] = ["Nome", "Data", "Local", "Preço"]
    var notePlaceholder: String = "  Anotações"
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TextField.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Novo Elemento"
        
        cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelNewElement))
        navigationItem.leftBarButtonItem = cancelButton!

        addButton = UIBarButtonItem(title: "Adicionar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addNewElement))
        navigationItem.rightBarButtonItem = addButton!
        
        view.addSubview(coverPhotoLabel)
        coverPhotoLabel.text = "Foto de Capa:"
        coverPhotoLabel.textColor = .black
        coverPhotoLabel.font = .systemFont(ofSize: view.frame.height  * 0.028, weight: .regular)
        
        view.addSubview(imageSpace)
        imageSpace.backgroundColor = #colorLiteral(red: 0.8626788259, green: 0.8627825379, blue: 0.8626434207, alpha: 1)
        
        view.addSubview(addPhotoButton)
        let configIcon = UIImage.SymbolConfiguration(pointSize: view.frame.height * 0.05, weight: .bold, scale: .large)
        addPhotoButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        addPhotoButton.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
        view.addSubview(notesTextView)
        notesTextView.backgroundColor = .clear
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = #colorLiteral(red: 0.7984885573, green: 0.8520841002, blue: 0.8903550506, alpha: 1)
        notesTextView.text = notePlaceholder
        notesTextView.textColor = UIColor.lightGray
        notesTextView.font = .systemFont(ofSize: 20)
        notesTextView.delegate = self
        notesTextView.returnKeyType = .done
        
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchDown)
        
        addConstraints()

    }
    
    func addConstraints() {
        coverPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/20).isActive = true
        coverPhotoLabel.bottomAnchor.constraint(equalTo: imageSpace.topAnchor, constant: -view.frame.height/40).isActive = true
        
        imageSpace.translatesAutoresizingMaskIntoConstraints = false
        imageSpace.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/7).isActive = true
        imageSpace.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/10).isActive = true
        imageSpace.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/10).isActive = true
        imageSpace.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/1.7).isActive = true
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.centerXAnchor.constraint(equalTo: imageSpace.centerXAnchor).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: imageSpace.centerYAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: imageSpace.bottomAnchor, constant: view.frame.height/50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/4.5).isActive = true
        
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/30).isActive = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageSpace.image = image
        imageSpace.contentMode = .scaleToFill
        addPhotoButton.tintColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "  Anotações" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = .systemFont(ofSize: 20)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = notePlaceholder
            textView.textColor = UIColor.lightGray
            textView.font = .systemFont(ofSize: 20)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TextField {
            cell.backgroundColor =  #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
            cell.placeHolder = placeholders[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
    @objc func cancelNewElement() {
        let alert = UIAlertController(title: "Tem certeza de que deseja descartar as alterações?", message: "", preferredStyle: .alert)
        
        let keepEditing = UIAlertAction(title: "Continuar Editando", style: .default, handler: nil)
        let cancelEdition = UIAlertAction(title: "Ignorar Alterações", style: .destructive) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(keepEditing)
        alert.addAction(cancelEdition)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addNewElement() {
        
    }
    
    @objc func addPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}


