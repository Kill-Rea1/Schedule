//
//  ProfileView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

//class ProfileView: BaseView {
class ProfileView: BaseScrollView {

    // MARK:- Properties
    
    fileprivate let padding: CGFloat = 20
    fileprivate let spacingButtons: CGFloat = 10
    fileprivate let spacingSections: CGFloat = 40
    public var nameTextFieldLeadingConstraint: NSLayoutConstraint!
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
    }
    
    // MARK:- UIKit
    
    public let nameTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .left
        textField.layer.borderWidth = 0
        textField.isEnabled = false
        textField.font = UIFont(name: "Comfortaa", size: 28)
        return textField
    }()
    
    public let nameChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить имя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let universityLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Comfortaa", size: 28)
        label.numberOfLines = 0
        return label
    }()
    
    public let universityChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить университет", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let groupLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Comfortaa", size: 28)
        label.numberOfLines = 0
        return label
    }()
    
    public let groupChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить группу", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let emailTextField: MainTextField = {
        let textField = MainTextField()
        textField.layer.borderWidth = 0
        textField.isEnabled = false
        textField.font = UIFont(name: "Comfortaa", size: 20)
        return textField
    }()
    
    public let emailChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить почту", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let adminImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "premium"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Сохранить изменения ", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont().myFont(), size: 24)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .clear
        button.tintColor = .black
        button.isEnabled = false
        return button
    }()
    
    // MARK:- Fileprivate Methods
        
    fileprivate func addViews() {
        addSubview(adminImageView)
        addSubview(nameTextField)
        addSubview(nameChangeButton)
        addSubview(universityLabel)
        addSubview(universityChangeButton)
        addSubview(groupLabel)
        addSubview(groupChangeButton)
        addSubview(emailTextField)
        addSubview(emailChangeButton)
        addSubview(saveButton)
        
        adminImageView.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, topAnchor, nil, .init(top: 20, left: padding, bottom: 0, right: 0), .init(width: 44, height: 44))
        nameTextField.addConstraints(nil, safeAreaLayoutGuide.trailingAnchor, topAnchor, nil, .init(top: 20, left: 0, bottom: 0, right: padding), .init(width: 0, height: 44))
        nameChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, nameTextField.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        universityLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, nameChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        universityChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, universityLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        groupLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, universityChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        groupChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, groupLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        emailTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, groupChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding), .init(width: 0, height: 44))
        emailChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, emailTextField.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        nameTextFieldLeadingConstraint = nameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding + adminImageView.frame.width + 12)
        nameTextFieldLeadingConstraint.isActive = true
        saveButton.addConstraints(nil, nil, emailChangeButton.bottomAnchor, nil, .init(top: spacingSections * 2, left: 0, bottom: 0, right: 0), .init(width: 0, height: 45))
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
