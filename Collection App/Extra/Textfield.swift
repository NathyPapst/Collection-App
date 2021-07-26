//
//  Textfield.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 22/07/21.
//

import UIKit

class TextField: UITableViewCell {
    
    let dataTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    var placeHolder: String? {
        didSet {
            guard let item = placeHolder else {return}
            dataTextField.placeholder = item
        }
    }
    
    func addConstraints() {
        contentView.addSubview(dataTextField)
        
        dataTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dataTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        dataTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        dataTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        dataTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
