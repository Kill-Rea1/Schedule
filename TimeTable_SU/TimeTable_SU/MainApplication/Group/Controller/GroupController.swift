//
//  GroupController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 04/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class GroupController: UIViewController {
    
    fileprivate var ref: DatabaseReference!
    fileprivate var students = [Student]()
    public var user: UserDB! {
        willSet {
            label.text = "Группа \(newValue.group)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadStudents()
        setupNavigationBar()
    }
    
    fileprivate let label: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: "Comfortaa", size: 30)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Группа"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? MainNavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    fileprivate func loadStudents() {
        ref = Database.database().reference().child("universities").child(user.university).child("groups").child(user.group).child("students")
        ref.observe(.value) { [weak self] (snapshot) in
            var _students = [Student]()
            for item in snapshot.children {
                let student = Student(snapshot: item as! DataSnapshot)
                if student.uid == self?.user.uid {
                    student.name += " (это вы)"
                }
                _students.append(student)
            }
            self?.students = _students
            self?.tableView.reloadData()
        }
    }

    
    fileprivate func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        //        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(StudentTableCell.self, forCellReuseIdentifier: StudentTableCell.reuseId)
    }
    
    fileprivate func setupView() {
        view.addSubview(label)
        view.addSubview(tableView)
        setupTableView()
        label.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .init(top: 10, left: 20, bottom: 0, right: 20))
        tableView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, label.bottomAnchor, view.bottomAnchor, .init(top: 10, left: 20, bottom: 0, right: 20))
//        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
//        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
//        tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension GroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableCell.reuseId, for: indexPath) as! StudentTableCell
        let student = students[indexPath.row]
        cell.nameLabel.text = student.name
        cell.adminButton.tag = indexPath.row
        cell.adminButton.addTarget(self, action: #selector(handleAdmin(sender:)), for: .touchUpInside)
        cell.emailLabel.text = student.email
        if student.isAdmin {
            cell.adminButton.alpha = 1
            cell.adminButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        } else {
            cell.adminButton.alpha = 0.5
            cell.adminButton.tintColor = .lightGray
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    @objc fileprivate func handleAdmin(sender: UIButton) {
        if user.isAdmin {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? StudentTableCell else {
                print("error")
                return }
            let student = students[indexPath.row]
            var studentRef = student.ref
            if student.uid == user.uid {
                return
            } else if student.isAdmin {
                cell.adminButton.alpha = 0.5
                cell.adminButton.tintColor = .lightGray
                studentRef?.updateChildValues(["isAdmin": false])
                studentRef = Database.database().reference().child("users").child(student.uid)
                studentRef?.updateChildValues(["isAdmin": false])
            } else {
                studentRef?.updateChildValues(["isAdmin": true])
                studentRef = Database.database().reference().child("users").child(student.uid)
                studentRef?.updateChildValues(["isAdmin": true])
                cell.adminButton.alpha = 1
                cell.adminButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            }
        } else {
            return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Все студенты"
        label.font = UIFont(name: "Comfortaa", size: 28)
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        return label
    }
}
