//
//  TimetableView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TimetableView: BaseView {
    
    // MARK:- Properties
    
    public var subjects = [[Subject]]()
    private let padding: CGFloat = 16
    
    // MARK:- Initialisation
    
    override func setupViews() {
        super.setupViews()
        tableViewSettings()
        addSubviews()
        addConstraints()
        tableView.alpha = 0
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
//        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK:- UIKit
    
    public let weekParity: CustomSegmentedControl = {
        let items = ["Все расписание", "Нечетная неделя", "Четная неделя"]
        let csc = CustomSegmentedControl(frame: .zero)
        csc.items = items
        return csc
    }()
    
    fileprivate let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "noSchedule")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let emptyLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Нет расписания"
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 35)
        return label
    }()
    
    public let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.alpha = 0.5
        return view
    }()
    
    public let tableView = UITableView(frame: .zero, style: .plain)
    
    fileprivate let dateLabel: MainLabel = {
        let label = MainLabel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "d MMMM"
        let text = formatter.string(from: date)
        label.text = text
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    fileprivate let weekLabel: MainLabel = {
        let label = MainLabel()
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        let text = weekOfYear % 2 == 0 ? "Нечетная неделя" : "Четная неделя"
        label.text = text
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        return label
    }()
    
    // MARK:- Fileprivate Methods
    
    fileprivate func tableViewSettings() {
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        tableView.register(TimetableCell.self, forCellReuseIdentifier: TimetableCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 90
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
    }
    
    fileprivate func addConstraints() {
        weekParity.addConstraints(leadingAnchor, trailingAnchor, topAnchor, nil, .init(top: padding, left: padding, bottom: 0, right: padding), .init(width: 0, height: 40))
        dateLabel.addConstraints(leadingAnchor, nil, weekParity.bottomAnchor, nil, .init(top: 3, left: 0, bottom: 0, right: 0), .init(width: 175, height: 20))
        weekLabel.addConstraints(leadingAnchor, nil, dateLabel.bottomAnchor, nil, .init(top: 3, left: 5, bottom: 0, right: 0), .init(width: 175, height: 20))
        tableView.addConstraints(leadingAnchor, trailingAnchor, weekLabel.bottomAnchor, bottomAnchor, .init(top: padding, left: padding, bottom: 0, right: padding))
        emptyView.addConstraints(leadingAnchor, trailingAnchor, weekLabel.bottomAnchor, bottomAnchor, .init(top: padding, left: padding, bottom: 0, right: padding))
        emptyImage.addConstraints(nil, nil, emptyView.topAnchor, nil, .init(top: 20, left: 0, bottom: 0, right: 0), .init(width: 150, height: 150))
        emptyImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyLabel.addConstraints(emptyView.leadingAnchor, emptyView.trailingAnchor, emptyImage.bottomAnchor, nil, .init(top: 30, left: 0, bottom: 0, right: 0), .init(width: 0, height: 55))
    }
    
    fileprivate func addSubviews() {
        addSubview(weekParity)
        addSubview(dateLabel)
        addSubview(weekLabel)
        addSubview(tableView)
        addSubview(emptyView)
        emptyView.addSubview(emptyImage)
        emptyView.addSubview(emptyLabel)
    }
}
