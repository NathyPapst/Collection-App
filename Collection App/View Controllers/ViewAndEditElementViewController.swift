//
//  ViewAndEditElementViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 26/07/21.
//

import UIKit

struct EditElementStruct {
    var name: String
    var date: String
    var place: String
    var price: String
}

class ViewAndEditElementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    let scrollView = UIScrollView()
    
    var editAndSaveButton: UIBarButtonItem!
    var imageSpace: UIImageView = UIImageView(frame: .zero)
    var cancelButton: UIBarButtonItem!
    var okButton: UIBarButtonItem!
    var coverPhotoLabel: UILabel = UILabel()
    var addPhotoButton: UIButton = UIButton(type: .custom)
    var placeholders: [String] = ["Nome", "Data", "Local", "Preço"]
    var notePlaceholder: String = "  Anotações"
    var notesTextView: UITextView = UITextView()
    var eraseButton: UIButton = UIButton(type: .custom)

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TextField.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var element: Element
    var collection: Collection
    
    init(elementAttributes: Element, collectionAttributes: Collection) {
        self.element = elementAttributes
        self.collection = collectionAttributes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Detalhes do Elemento"
        
        editAndSaveButton = UIBarButtonItem(title: "Editar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editElement))
        navigationItem.rightBarButtonItem = editAndSaveButton!
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.1)
        
        scrollView.addSubview(coverPhotoLabel)
        coverPhotoLabel.text = "Foto de Capa:"
        coverPhotoLabel.textColor = .black
        coverPhotoLabel.font = .systemFont(ofSize: view.frame.height  * 0.028, weight: .regular)

        scrollView.addSubview(imageSpace)
        imageSpace.backgroundColor = #colorLiteral(red: 0.8626788259, green: 0.8627825379, blue: 0.8626434207, alpha: 1)
        imageSpace.image = UIImage(data: element.photo ?? Data())

        imageSpace.addSubview(addPhotoButton)
        let configIcon = UIImage.SymbolConfiguration(pointSize: view.frame.height * 0.05, weight: .bold, scale: .large)
        addPhotoButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        addPhotoButton.tintColor = .clear

        scrollView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear

        scrollView.addSubview(notesTextView)
        notesTextView.backgroundColor = .clear
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = #colorLiteral(red: 0.7984885573, green: 0.8520841002, blue: 0.8903550506, alpha: 1)
        notesTextView.textColor = UIColor.lightGray
        notesTextView.font = .systemFont(ofSize: 20)
        notesTextView.delegate = self
        notesTextView.returnKeyType = .done
        notesTextView.isUserInteractionEnabled = false
        notesTextView.text = element.notes
        print("NTV \(notesTextView.text)")
        print("EN\(element.notes)")

        scrollView.addSubview(eraseButton)
        eraseButton.setTitle("Apagar Elemento", for: .normal)
        eraseButton.setTitleColor(.systemRed, for: .normal)
        
        addConstraints()
    }
    
    func addConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        coverPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: view.frame.width/20).isActive = true
        coverPhotoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height/50).isActive = true

        imageSpace.translatesAutoresizingMaskIntoConstraints = false
        imageSpace.topAnchor.constraint(equalTo: coverPhotoLabel.bottomAnchor, constant: view.frame.height/50).isActive = true
        imageSpace.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: view.frame.width/10).isActive = true
        imageSpace.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -view.frame.width/10).isActive = true
        imageSpace.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -view.frame.height/1.25).isActive = true
        imageSpace.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.centerXAnchor.constraint(equalTo: imageSpace.centerXAnchor).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: imageSpace.centerYAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: imageSpace.bottomAnchor, constant: view.frame.height/50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        notesTextView.heightAnchor.constraint(equalToConstant: view.frame.height/5).isActive = true
        
        eraseButton.translatesAutoresizingMaskIntoConstraints = false
        eraseButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: view.frame.height/30).isActive = true
        eraseButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: view.frame.width/4).isActive = true
        eraseButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -view.frame.width/4).isActive = true
        eraseButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        eraseButton.heightAnchor.constraint(equalToConstant: view.frame.height/10).isActive = true
        eraseButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
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
            
            switch indexPath.row{
            case 0:
                cell.dataTextField.text = element.name
                break
                
            case 1:
                cell.dataTextField.text = element.date
                break
                
            case 2:
                cell.dataTextField.text = element.place
                break
                
            case 3:
                cell.dataTextField.text = element.price
                break
            default:
                print("Falhou")
            }
            cell.placeHolder = placeholders[indexPath.row]
            cell.dataTextField.isUserInteractionEnabled = false
            return cell
        }
        return UITableViewCell()
    }
    
    
    @objc func editElement() {
        for cell in tableView.visibleCells {
            let text = cell as! TextField
            text.dataTextField.isUserInteractionEnabled = true
        }
        
        notesTextView.isUserInteractionEnabled = true
        
        editAndSaveButton = UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveElement))
        navigationItem.rightBarButtonItem = editAndSaveButton!
    }
    
    @objc func saveElement() {
        
    }
}
