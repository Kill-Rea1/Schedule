//
//  SettingsView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 04/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class SettingsView: BaseView {

    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(nameTextField)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, universityLabel, universityButton, groupLabel, groupyButton, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public let nameLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Имя"
        label.font = UIFont(name: "Comfortaa", size: 28)
        return label
    }()
    
    public let nameTextField = MainTextField()
    public let universityLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Университет"
        label.font = UIFont(name: "Comfortaa", size: 28)
        return label
    }()
    public let universityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Университет", for: .normal)
        button.titleLabel?.numberOfLines = 5
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    public let groupLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Группа"
        label.font = UIFont(name: "Comfortaa", size: 28)
        return label
    }()
    public let groupyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Группа", for: .normal)
        button.titleLabel?.numberOfLines = 5
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
