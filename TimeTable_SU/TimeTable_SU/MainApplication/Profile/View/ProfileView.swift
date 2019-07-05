//
//  ProfileView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ProfileView: BaseView {
    
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
    
    public let emaiTextField: MainTextField = {
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
    
    // MARK:- Fileprivate Methods
        
    fileprivate func addViews() {
        addSubview(adminImageView)
        addSubview(nameTextField)
        addSubview(nameChangeButton)
        addSubview(universityLabel)
        addSubview(universityChangeButton)
        addSubview(groupLabel)
        addSubview(groupChangeButton)
        addSubview(emaiTextField)
        addSubview(emailChangeButton)
        
        adminImageView.addConstraints(leadingAnchor, nil, topAnchor, nil, .init(top: 0, left: padding, bottom: 0, right: 0), .init(width: 44, height: 44))
        nameTextField.addConstraints(nil, trailingAnchor, topAnchor, nil, .init(top: 0, left: 0, bottom: 0, right: padding), .init(width: 0, height: 44))
        nameChangeButton.addConstraints(leadingAnchor, nil, nameTextField.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        universityLabel.addConstraints(leadingAnchor, trailingAnchor, nameChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        universityChangeButton.addConstraints(leadingAnchor, nil, universityLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        groupLabel.addConstraints(leadingAnchor, trailingAnchor, universityChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding))
        groupChangeButton.addConstraints(leadingAnchor, nil, groupLabel.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        emaiTextField.addConstraints(leadingAnchor, trailingAnchor, groupChangeButton.bottomAnchor, nil, .init(top: spacingSections, left: padding, bottom: 0, right: padding), .init(width: 0, height: 44))
        emailChangeButton.addConstraints(leadingAnchor, nil, emaiTextField.bottomAnchor, nil, .init(top: spacingButtons, left: padding, bottom: 0, right: 0), .init(width: 0, height: 20))
        nameTextFieldLeadingConstraint = nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding + adminImageView.frame.width + 12)
        nameTextFieldLeadingConstraint.isActive = true
    }
}
