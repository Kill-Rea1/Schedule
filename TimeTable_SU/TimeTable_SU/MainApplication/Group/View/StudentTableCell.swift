//
//  StudentTableCell.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class StudentTableCell: BaseCell {
    
    static let reuseId = "studentCell"
    
    override func setupViews() {
        super.setupViews()
        configureStudentStackView()
        configureStackView()
    }
    
    fileprivate func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [studentStackView, UIView(), adminStackView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.addConstraints(leadingAnchor, trailingAnchor, topAnchor, bottomAnchor)
    }
    
    fileprivate func configureStudentStackView() {
        studentStackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        studentStackView.spacing = 8
        studentStackView.axis = .vertical
    }
    
    fileprivate var studentStackView: UIStackView!
    
    public let nameLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        return label
    }()
    
    public let emailLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 14)
        label.textAlignment = .left
        return label
    }()
    
    lazy fileprivate var adminStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [adminButton, adminLabel])
        stackView.axis = .vertical
        stackView.backgroundColor = .purple
        stackView.spacing = 4
        return stackView
    }()
    
    public let adminLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 14)
        label.text = "Admin"
        return label
    }()
    
    public let adminButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "premium"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
