//
//  MenuViewController.swift
//  Timetable
//
//  Created by Кирилл Иванов on 11/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

extension MenuController: UINavigationControllerDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigation = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let containerController = navigation?.viewControllers.first as? MainController
        containerController?.didSelectMenuItem(indexPathRow: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class MenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.title = "Меню"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
    }
    
    fileprivate func setupTableView() {
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId, for: indexPath) as! MenuTableCell
        let menuRow = Menu(rawValue: indexPath.row)
        cell.myLabel.text = menuRow?.description
        cell.iconImageView.image = menuRow?.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
