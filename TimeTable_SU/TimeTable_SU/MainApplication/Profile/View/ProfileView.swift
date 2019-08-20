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
    fileprivate let spacingSections: CGFloat = 30
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        createToolBar()
        hideKeyboard()
        addViews()
    }
    
    // MARK:- UIKit
    
    public let nameTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .left
        textField.layer.borderWidth = 0
        textField.isEnabled = false
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 28)
        return textField
    }()
    
    public let nameChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить имя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        return button
    }()
    
    public let universityLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 28)
        label.numberOfLines = 0
        return label
    }()
    
    public let universityChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить университет", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        return button
    }()
    
    public let groupLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 28)
        label.numberOfLines = 0
        return label
    }()
    
    public let groupChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить группу", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        return button
    }()
    
    public let passwordChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить пароль", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        return button
    }()
    
    public let adminImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "premium"))
        return imageView
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Сохранить изменения ", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 24)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .clear
        button.tintColor = .black
        button.isEnabled = false
        return button
    }()
    
    // MARK:- Fileprivate Methods
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexibleButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        nameTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
        
    fileprivate func addViews() {
        addSubview(adminImageView)
        addSubview(nameTextField)
        addSubview(nameChangeButton)
        addSubview(passwordChangeButton)
        addSubview(universityLabel)
        addSubview(universityChangeButton)
        addSubview(groupLabel)
        addSubview(groupChangeButton)
        addSubview(saveButton)
        adminImageView.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, topAnchor, nil, .init(top: 20, left: padding, bottom: 0, right: 0), .init(width: 44, height: 44))
        nameTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, adminImageView.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: padding), .init(width: 0, height: 44))
        nameChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, nameTextField.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        passwordChangeButton.addConstraints(nil, safeAreaLayoutGuide.trailingAnchor, nameTextField.bottomAnchor, nil, .init(top: spacingButtons, left: 0, bottom: 0, right: padding), .init(width: 0, height: 20))
        universityLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, nameChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        universityChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, universityLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        groupLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, universityChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        groupChangeButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, groupLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        saveButton.addConstraints(nil, nil, groupChangeButton.bottomAnchor, bottomAnchor, .init(top: spacingSections, left: 0, bottom: 50, right: 0), .init(width: 0, height: 50))
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
