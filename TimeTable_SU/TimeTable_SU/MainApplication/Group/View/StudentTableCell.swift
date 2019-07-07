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
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        setupContenView()
        
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    // MARK:- UIKit
    
    public let nameLabel: MainLabel = {
        let label = MainLabel()
        label.textAlignment = .left
        return label
    }()
    
    public let emailLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
    
    // MARK:- Fileprivate Methods
    
    fileprivate func configure() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(adminLabel)
        contentView.addSubview(adminButton)
        nameLabel.addConstraints(contentView.leadingAnchor, nil, contentView.topAnchor, nil, .init(top: 10, left: 10, bottom: 0, right: 0), .init(width: 0, height: 30))
        emailLabel.addConstraints(contentView.leadingAnchor, adminLabel.leadingAnchor, nameLabel.bottomAnchor, contentView.bottomAnchor, .init(top: 20, left: 10, bottom: 10, right: 5), .init(width: 0, height: 15))
        adminButton.addConstraints(nil, contentView.trailingAnchor, contentView.topAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: 10), .init(width: 40, height: 40))
        adminLabel.addConstraints(nil, contentView.trailingAnchor, adminButton.bottomAnchor, nil, .init(top: 0, left: 0, bottom: 0, right: 10), .init(width: 0, height: 30))
    }
    
    fileprivate func setupContenView() {
        contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 14
    }
}
