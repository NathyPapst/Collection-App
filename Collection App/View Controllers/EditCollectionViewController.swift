//
//  EditCollectionViewController.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 26/07/21.
//

import UIKit
import Photos

struct EditCollectionStruct {
    var name: String
}

class EditCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var imageSpace: UIImageView = UIImageView(frame: .zero)
    var cancelButton: UIBarButtonItem!
    var okButton: UIBarButtonItem!
    var coverPhotoLabel: UILabel = UILabel()
    var addPhotoButton: UIButton = UIButton(type: .custom)
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
      table.register(TextField.self, forCellReuseIdentifier: "cell")
      return table
    }()
    
    var collection: Collection?
    var collectionDelegate: CreateAndEditCollectionViewControllerDelegate?
    var mainDelegate: MainViewControllerDelegate?
    
    var nameField: String = ""
    var photoField: Data = Data()
    
    init(collectionAttributes: Collection) {
        self.collection = collectionAttributes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.894770503, green: 0.9582068324, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1408720911, green: 0.1896772087, blue: 0.7425404191, alpha: 1)
        title = "Editar Coleção"
        
        cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelEdition))
        navigationItem.leftBarButtonItem = cancelButton!
        
        okButton = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveEdition))
        navigationItem.rightBarButtonItem = okButton!
        
        view.addSubview(coverPhotoLabel)
        coverPhotoLabel.text = "Foto de Capa:"
        coverPhotoLabel.textColor = .black
        coverPhotoLabel.font = .systemFont(ofSize: view.frame.height  * 0.028, weight: .regular)

        view.addSubview(imageSpace)
        imageSpace.backgroundColor = #colorLiteral(red: 0.8626788259, green: 0.8627825379, blue: 0.8626434207, alpha: 1)
        imageSpace.image = UIImage(data: collection?.photo ?? Data())

        view.addSubview(addPhotoButton)
        let configIcon = UIImage.SymbolConfiguration(pointSize: view.frame.height * 0.05, weight: .bold, scale: .large)
        addPhotoButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        addPhotoButton.tintColor = .clear
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        addPhotoButton.addTarget(self, action: #selector(callPermition), for: .touchDown)

        addConstraints()
    }
    
    func addConstraints() {
        imageSpace.translatesAutoresizingMaskIntoConstraints = false
        imageSpace.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/7).isActive = true
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
        tableView.topAnchor.constraint(equalTo: imageSpace.bottomAnchor, constant: view.frame.height/50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageSpace.image = image
        imageSpace.contentMode = .scaleToFill
        self.dismiss(animated: true, completion: nil)
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
            cell.dataTextField.text = collection?.name
            return cell
        }
        return UITableViewCell()
    }
    
    enum textFieldData: Int {
        case name = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(newValue), for: .editingChanged)
    }
    
    @objc func newValue(_ textField: UITextField) {
        nameField = textField.text ?? ""
    }
    
    @objc func cancelEdition() {
        let alert = UIAlertController(title: "Tem certeza de que deseja descartar as alterações?", message: "", preferredStyle: .alert)
        
        let keepEditing = UIAlertAction(title: "Continuar Editando", style: .default, handler: nil)
        let cancelEdition = UIAlertAction(title: "Ignorar Alterações", style: .destructive) { (_) in
            CoreDataStack.shared.mainContext.rollback()
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(keepEditing)
        alert.addAction(cancelEdition)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveEdition() {
        collection?.name = nameField
        saveCollectionPhoto()
        
        collectionDelegate?.didRegister()
        try? CoreDataStack.shared.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @objc func callPermition(){
            checkPermission()
        }
        
    @objc func checkPermission(){
        let photoAutorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAutorizationStatus{
        case.authorized:
            self.addPhoto()
            print("Acesso permitido pelo usuário")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                DispatchQueue.main.async {
                    print("Status is \(newStatus)")
                    if newStatus == PHAuthorizationStatus.authorized{
                        self.addPhoto()
                        print("Acesso autorizado")
                    }
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User did not have access to photo album")
        case .denied:
            print("User has denied permission")
            break
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    func saveCollectionPhoto() {
        let imageData = imageSpace.image?.pngData()
        photoField = imageData ?? Data()
        collection?.photo = photoField
        let photo = UIImage(data: photoField)
        imageSpace.image = photo
    }
}



