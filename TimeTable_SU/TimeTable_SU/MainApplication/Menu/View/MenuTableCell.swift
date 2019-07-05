//
//  MenuTableCell.swift
//  Timetable
//
//  Created by Кирилл Иванов on 11/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class IconImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return .init(width: 38, height: 38)
    }
}

class MenuTableCell: BaseCell {
    
    static let reuseId = "menuCell"
    
    override func setupViews() {
        setupStackView()
        backgroundColor = .clear
    }
    
    public let iconImageView: IconImageView = {
        let imageView = IconImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        return imageView
    }()
    
    public let myLabel = MainLabel()
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, myLabel, UIView()])
        addSubview(stackView)
        stackView.spacing = 12
        stackView.addConstraints(leadingAnchor, trailingAnchor, topAnchor, bottomAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 12)
    }
}
