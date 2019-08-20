//
//  TimetableCell.swift
//  Timetable
//
//  Created by Кирилл Иванов on 04/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TimetableCell: BaseCell {
    
    // MARK:- Properties
    
    static let reuseId = "timetableCell"
    public var subject: Subject! {
        didSet {
            subjectLabel.text = subject.subjectName
            classroomLabel.text = subject.classroom + "ауд."
            startSubjectTime.text = subject.startTime
            endSubjectTime.text = subject.endTime
            typeSubjectLabel.text = subject.subjectType
            weekParityLabel.text = subject.parity
        }
    }
    
    // MARK:- Initialisation
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        contentView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        contentView.layer.cornerRadius = 14
        layer.cornerRadius = 14
        clipsToBounds = true
        addSubviews()
        constraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: .init(top: 0, left: 0, bottom: 2, right: 0))
    }
    
    // MARK:- UIKit
    
    fileprivate let subjectLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    fileprivate let classroomLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 12)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    fileprivate let startSubjectTime: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 12)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    fileprivate let endSubjectTime: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 12)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    fileprivate let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let typeSubjectLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    fileprivate let weekParityLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    // MARK:- Fileprivate Methods
    
    fileprivate func addSubviews() {
        contentView.addSubview(subjectLabel)
        contentView.addSubview(startSubjectTime)
        contentView.addSubview(endSubjectTime)
        contentView.addSubview(classroomLabel)
        contentView.addSubview(clockImage)
        contentView.addSubview(typeSubjectLabel)
        contentView.addSubview(weekParityLabel)
    }
    
    fileprivate func constraints() {
        subjectLabel.addConstraints(contentView.leadingAnchor, contentView.trailingAnchor, contentView.topAnchor, nil, .init(top: 30, left: 40, bottom: 0, right: 0), .init(width: 0, height: 20))
        startSubjectTime.addConstraints(contentView.leadingAnchor, nil, contentView.topAnchor, nil, .init(top: 5, left: 7, bottom: 0, right: 0), .init(width: 40, height: 20))
        clockImage.addConstraints(contentView.leadingAnchor, nil, contentView.topAnchor, nil, .init(top: 30, left: 12, bottom: 0, right: 0), .init(width: 30, height: 30))
        endSubjectTime.addConstraints(contentView.leadingAnchor, nil, clockImage.bottomAnchor, nil, .init(top: 5, left: 7, bottom: 0, right: 0), .init(width: 40, height: 20))
        classroomLabel.addConstraints(contentView.leadingAnchor, contentView.trailingAnchor, subjectLabel.bottomAnchor, nil, .init(top: 10, left: 40, bottom: 0, right: 0), .init(width: 0, height: 15))
        weekParityLabel.addConstraints(contentView.leadingAnchor, contentView.centerXAnchor, contentView.topAnchor, nil, .init(top: 5, left: 20, bottom: 0, right: 20), .init(width: 0, height: 20))
        typeSubjectLabel.addConstraints(contentView.centerXAnchor, contentView.trailingAnchor, contentView.topAnchor, nil, .init(top: 5, left: 20, bottom: 0, right: -20), .init(width: 0, height: 20))
    }
}
