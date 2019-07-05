//
//  SearchController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 29/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

extension SearchController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterData.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let single = data[indexPath.row]
        var cellStr: String?
        if isSearching {
            cellStr = filterData[indexPath.row]
        } else {
            cellStr = single.name
        }
        cell.textLabel?.text = cellStr
        cell.textLabel?.numberOfLines = 5
        cell.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        cell.textLabel?.font = UIFont(name: UIFont().myFont(), size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if prevVC is RegistrationController {
            if let vc = prevVC as? RegistrationController {
                if isUniversitySearching {
                    vc.university = data[indexPath.row].name
                } else if isGroupSearching {
                    vc.group = data[indexPath.row]
                }
                vc.isMovedFromSearching = false
                vc.isAdmin = false
            }
        } else {
            if let vc = prevVC as? ProfileController {
                if isUniversitySearching {
                    vc.university = data[indexPath.row].name
                } else if isGroupSearching {
                    vc.group = data[indexPath.row].name
                }
//                vc.isMovedFromSearching = false
//                vc.isAdmin = false
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filterData = dataStr
            filterData = filterData.filter({$0.range(of: searchBar.text!, options: .caseInsensitive) != nil })
            tableView.reloadData()
        }
    }
}

class SearchController: UIViewController {
    
    // MARK:- Properties
    
    fileprivate var ref: DatabaseReference!
    fileprivate var dataStr = [String]()
    fileprivate var data = [University]()
    fileprivate var filterData: [String]!
    public var selectedUniversity: String!
    public var isUniversitySearching = true
    public var isGroupSearching = false
    weak var prevVC: UIViewController!
    
    fileprivate let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    fileprivate let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    fileprivate var isSearching = false
    
    // MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabase()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupViews()
        setupDelegates()
        setupNavigationBer()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    // MARK:- Private Methods
    
    fileprivate func setupNavigationBer() {
        let newBackButton = UIBarButtonItem(title: "Регистрация", style: .plain, target: self, action: #selector(handleBack))
        newBackButton.tintColor = .black
        navigationItem.backBarButtonItem = newBackButton
        navigationItem.title = isUniversitySearching ? "Выберите университет" : "Выберите группу"
    }
    
    fileprivate func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont().myFont(), size: 16)!]
        definesPresentationContext = true
    }
    
    
    fileprivate func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .init(), .init(width: 0, height: 40))
        tableView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, searchBar.bottomAnchor, view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    @objc fileprivate func handleBack() {
        print("back")
        guard let prevVC = prevVC as? RegistrationController else {
            navigationController?.popViewController(animated: true)
            return
        }
        if isUniversitySearching && prevVC.university == nil {
            prevVC.isMovedFromSearching = true
        } else if isGroupSearching && prevVC.university == nil && prevVC.group == nil {
            prevVC.isMovedFromSearching = true
        }
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func loadDatabase() {
        if isUniversitySearching {
            ref = Database.database().reference().child("universities")
            ref.observe(.value) { [weak self] (snapshot) in
                var _universities = Array<University>()
                var _universitiesStr = Array<String>()
                for item in snapshot.children {
                    let uni = University(snapshot: item as! DataSnapshot)
                    _universities.append(uni)
                    _universitiesStr.append(uni.name)
                }
                self?.dataStr = _universitiesStr
                self?.data = _universities
                self?.tableView.reloadData()
            }
        } else if isGroupSearching {
            ref = Database.database().reference().child("universities").child(selectedUniversity).child("groups")
            ref.observe(.value) { [weak self] (snapshot) in
                var _groups = Array<University>()
                var _groupsStr = Array<String>()
                for item in snapshot.children {
                    let group = University(snapshot: item as! DataSnapshot)
                    _groups.append(group)
                    _groupsStr.append(group.name)
                }
                self?.data = _groups
                self?.dataStr = _groupsStr
                self?.tableView.reloadData()
            }
        }
    }
}
