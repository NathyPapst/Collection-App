//
//  ViewAndEditElementViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 26/07/21.
//

import UIKit
import Photos

struct EditElementStruct {
    var name: String
    var date: String
    var place: String
    var price: String
}

class ViewAndEditElementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
    
    var elementsDelegate: CreateAndEditElementsViewControllerDelegate?
    var editDelegate: CreateAndEditElementsViewControllerDelegate?
    var mainElementsDelegate: ViewElementsViewControllerDelegate?
    var element: Element?
    var photoField = Data()
    var nameField: String = ""
    var dateField: String = ""
    var placeField: String = ""
    var priceField: String = ""
    
    init(elementAttributes: Element) {
        self.element = elementAttributes
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
        imageSpace.image = UIImage(data: element?.photo ?? Data())

        view.addSubview(addPhotoButton)
        let configIcon = UIImage.SymbolConfiguration(pointSize: view.frame.height * 0.05, weight: .bold, scale: .large)
        addPhotoButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        addPhotoButton.tintColor = .clear
        addPhotoButton.addTarget(self, action: #selector(editPhoto), for: .touchDown)
        addPhotoButton.isUserInteractionEnabled = false
        

        scrollView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear

        scrollView.addSubview(notesTextView)
        notesTextView.backgroundColor = .clear
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = #colorLiteral(red: 0.7984885573, green: 0.8520841002, blue: 0.8903550506, alpha: 1)
        notesTextView.textColor = UIColor.black
        notesTextView.font = .systemFont(ofSize: 20)
        notesTextView.delegate = self
        notesTextView.returnKeyType = .done
        notesTextView.isUserInteractionEnabled = false
        notesTextView.text = element?.notes

        scrollView.addSubview(eraseButton)
        eraseButton.setTitle("Apagar Elemento", for: .normal)
        eraseButton.setTitleColor(.systemRed, for: .normal)
        eraseButton.addTarget(self, action: #selector(eraseElement), for: .touchDown)
        
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageSpace.image = image
        imageSpace.contentMode = .scaleToFill
        saveElementPhoto()
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
            cell.selectionStyle = .none
            
            switch indexPath.row{
            case 0:
                cell.dataTextField.text = element?.name
                break
                
            case 1:
                cell.dataTextField.text = element?.date
                break
                
            case 2:
                cell.dataTextField.text = element?.place
                break
                
            case 3:
                cell.dataTextField.text = element?.price
                break
            default:
                print("Falhou")
            }
            cell.placeHolder = placeholders[indexPath.row]
            cell.dataTextField.tag = indexPath.row
            cell.dataTextField.delegate = self
            cell.dataTextField.isUserInteractionEnabled = false
            return cell
        }
        return UITableViewCell()
    }
    
    enum TextFieldData: Int {
        case name = 0
        case date = 1
        case place = 2
        case price = 3
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(newValue), for: .editingChanged)
    }
    
    @objc func newValue(_ textField: UITextField) {
        switch textField.tag {
        case TextFieldData.name.rawValue:
            guard let text = self.element?.name else {return}
            nameField = textField.text ?? text
            
        case TextFieldData.date.rawValue:
            guard let text = self.element?.date else {return}
            dateField = textField.text ?? text
            
        case TextFieldData.place.rawValue:
            guard let text = self.element?.place else {return}
            placeField = textField.text ?? text
            
        case TextFieldData.price.rawValue:
            guard let text = self.element?.price else {return}
            priceField = textField.text ?? text
        default:
            break
        }
    }
    
    @objc func editElement() {
        for cell in tableView.visibleCells {
            let text = cell as! TextField
            text.dataTextField.isUserInteractionEnabled = true
        }
        
        notesTextView.isUserInteractionEnabled = true
        addPhotoButton.isUserInteractionEnabled = true
        
        editAndSaveButton = UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveElement))
        navigationItem.rightBarButtonItem = editAndSaveButton!
    }
    
    @objc func saveElement() {
        guard let element = self.element else {return}

        element.name = nameField
        element.date = dateField
        element.place = placeField
        element.price = priceField
        element.notes = notesTextView.text
        
        print("oi\(element.name)")
        print("oii\(nameField)")

        try? CoreDataStack.shared.save()
        editDelegate?.didRegister()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func saveElementPhoto() {
        let imageData = imageSpace.image?.pngData()
        photoField = imageData ?? Data()
        element?.photo = photoField
        let photo = UIImage(data: photoField)
        imageSpace.image = photo
    }
    
    @objc func eraseElement() {
        let alert = UIAlertController(title: "Tem certeza que deseja apagar esse elemento?", message: "Se exclui-lo, você perderá todas as informações contidas nele", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Deletar Elemento", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
            _ = try? CoreDataStack.shared.deleteElement(element: self.element!)
            self.editDelegate?.didRegister()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelDelete = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancelDelete)
        
        present(alert, animated: true, completion: nil)
    }
}
