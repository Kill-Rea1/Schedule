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
            cellStr = single
        }
        cell.textLabel?.text = cellStr
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        cell.textLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let selectedData = data[indexPath.row]
        if isGroupSearching {
            checkIfStudentsExist(selectedData)
        }
        sendData(data: selectedData)
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filterData = data
            filterData = filterData.filter({$0.range(of: searchBar.text!, options: .caseInsensitive) != nil })
            tableView.reloadData()
        }
    }
}

class SearchController: UIViewController {
    
    // MARK:- Properties
    
    fileprivate var isSearching = false
    fileprivate var ref: DatabaseReference!
    fileprivate var data = [String]()
    fileprivate var filterData: [String]!
    public var selectedUniversity: String!
    public var prevData: String!
    public var isUniversitySearching = true
    public var isGroupSearching = false
    weak var prevVC: UIViewController!
    public var isAdmin: Bool! {
        willSet {
            guard let isAdmin = newValue else { return }
            if prevVC is ProfileController {
                let vc = prevVC as! ProfileController
                vc.isAdmin = isAdmin
            } else {
                let vc = prevVC as! RegistrationController
                vc.isAdmin = isAdmin
            }
        }
    }
    
    // MARK:- UIKit
    
    lazy var alertController: CustomAlertController = {
        let view = CustomAlertController()
        view.alpha = 0
        view.myTextView.text = isUniversitySearching ? "Введите университет.." : "Введите группу.."
        view.titleLabel.text = isUniversitySearching ? "Новый университет" : "Новая группа"
        return view
    }()
    
    fileprivate let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.isTranslucent = false
        return bar
    }()
    
    fileprivate let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabase()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupViews()
        setupDelegates()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    // MARK:- Private Methods
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = isUniversitySearching ? "Выберите университет" : "Выберите группу"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(handleAdd))
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func handleAdd() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alertController.alpha = 1
        })
    }
    
    fileprivate func sendData(data: String) {
        if let vc = prevVC as? RegistrationController {
            if isUniversitySearching {
                vc.university = data
            } else if isGroupSearching {
                vc.group = data
            }
        } else if let vc = prevVC as? ProfileController {
            if isUniversitySearching {
                vc.university = data
            } else if isGroupSearching {
                vc.group = data
            }
        }
    }
    
    @objc fileprivate func handleSave() {
        guard let newText = alertController.myTextView.text, newText != "", newText != "Введите университет..", newText != "Введите группу.." else {
            handleCancel()
            return
        }
        if isUniversitySearching {
            if !data.contains(newText) {
                ref = Database.database().reference()
                ref.child("universities").child(newText).setValue(["name": newText])
                sendData(data: newText)
            }
        } else {
            if !data.contains(newText) {
                ref = Database.database().reference()
                ref.child("universities").child(selectedUniversity).child("groups").child(newText).setValue(["name": newText])
                checkIfStudentsExist(newText)
                sendData(data: newText)
            }
        }
        handleCancel()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleCancel() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alertController.alpha = 0
        })
    }
    
    fileprivate func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont(name: Comfortaa.regular.rawValue, size: 16)!]
        definesPresentationContext = true
    }
    
    fileprivate func checkIfStudentsExist(_ selectedData: String) {
        ref = Database.database().reference()
        ref.child("universities").child(selectedUniversity).child("groups").child(selectedData).observeSingleEvent(of: .value) { [weak self](snapshot) in
            if !snapshot.hasChild("students") {
                self?.isAdmin = true
            } else {
                self?.isAdmin = false
            }
        }
    }
    
    
    fileprivate func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(alertController)
        let window = UIApplication.shared.keyWindow
        alertController.frame = window?.frame ?? .zero
        searchBar.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .init(top: 10, left: 0, bottom: 0, right: 0), .init(width: 0, height: 40))
        tableView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, searchBar.bottomAnchor, view.safeAreaLayoutGuide.bottomAnchor)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        alertController.confirmButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        alertController.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc fileprivate func handleBack() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func loadDatabase() {
        if isUniversitySearching {
            ref = Database.database().reference().child("universities")
            ref.observe(.value) { [weak self] (snapshot) in
                var _universities = Array<String>()
                for item in snapshot.children {
                    let university = University(snapshot: item as! DataSnapshot)
                    _universities.append(university.name)
                }
                self?.data = _universities
                self?.tableView.reloadData()
            }
        } else if isGroupSearching {
            ref = Database.database().reference().child("universities").child(selectedUniversity).child("groups")
            ref.observe(.value) { [weak self] (snapshot) in
                var _groups = Array<String>()
                for item in snapshot.children {
                    let group = University(snapshot: item as! DataSnapshot)
                    _groups.append(group.name)
                }
                self?.data = _groups
                self?.tableView.reloadData()
            }
        }
    }
}
