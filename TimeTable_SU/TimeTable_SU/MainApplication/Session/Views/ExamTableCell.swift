//
//  ExamTableCell.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ExamTableCell: BaseCell {
    
    // MARK:- Properties
    
    static let reuseId = "examCell"
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        configure()
    }
    
    // MARK:- UIKit
    
    public let nameLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    public let classroomLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 12)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    public let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let timeLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 16)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    public let typeLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: UIFont().myFont(), size: 14)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    // MARK:- Fileprivate Method
    
    fileprivate func configure() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(classroomLabel)
        contentView.addSubview(clockImage)
        contentView.addSubview(timeLabel)
        contentView.addSubview(typeLabel)
        
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.addConstraints(nil, nil, contentView.topAnchor, nil, .init(top: 30, left: 0, bottom: 0, right: 0), .init(width: 0, height: 25))
        classroomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        classroomLabel.addConstraints(nil, nil, nameLabel.bottomAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: 0), .init(width: 0, height: 20))
        clockImage.addConstraints(contentView.leadingAnchor, nil, contentView.topAnchor, nil, .init(top: 15, left: 10, bottom: 0, right: 0), .init(width: 35, height: 35))
        timeLabel.centerXAnchor.constraint(equalTo: clockImage.centerXAnchor).isActive = true
        timeLabel.addConstraints(nil, nil, clockImage.bottomAnchor, nil, .init(top: 10, left: 0, bottom: 0, right: 0), .init(width: 50, height: 20))
        typeLabel.addConstraints(nil, contentView.trailingAnchor, contentView.topAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: 10), .init(width: 100, height: 35))
    }
}
