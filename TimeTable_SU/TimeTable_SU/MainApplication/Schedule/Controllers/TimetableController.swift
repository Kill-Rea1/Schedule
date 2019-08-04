//
//  ViewController.swift
//  Timetable
//
//  Created by Кирилл Иванов on 04/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class TimetableController: UIViewController, MGSwipeTableCellDelegate {
    
    // MARK:- Properties
    
    fileprivate var ref: DatabaseReference!
    fileprivate var refreshControl = UIRefreshControl()
    fileprivate var user: UserDB! {
        willSet {
            if newValue.isAdmin {
                let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(handleAdd))
                let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(refresh))
                navigationItem.rightBarButtonItems = [addButton, refreshButton]
            } else {
                let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(refresh))
                navigationItem.rightBarButtonItems = [refreshButton]
            }
        }
    }
    fileprivate var week = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
    fileprivate var subjects = [[Subject]]()
    public let timetableView = TimetableView()
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupView()
        setupSpinner()
        checkIfUserLoggedIn()
        configureTableView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupTargets()
        setupNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserLoggedIn()
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.isAddControllerOpened = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    // MARK:- Private Methods
    
    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            ref.child("users").child(uid!).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                self?.user = UserDB(snapshot: snapshot)
                self?.spinner.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                DispatchQueue.main.async(execute: {
                    self?.timetableView.weekParity.selectedSegmentIndex = 0
                    self?.loadData()
                })
            }
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Расписание"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
        let enterController = EnterController()
        navigationController.viewControllers = [enterController]
        UserDefaults.standard.setIsLoggedIn(value: false)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    @objc fileprivate func handleAdd() {
        guard let user = user else { return }
        let addSubjectVC = AddSubjectController()
        addSubjectVC.user = user
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.isAddControllerOpened = true
        navigationController?.pushViewController(addSubjectVC, animated: true)
    }
    
    fileprivate func setupTargets() {
        timetableView.weekParity.addTarget(self, action: #selector(changedWeek), for: .valueChanged)
    }

    fileprivate func configureTableView() {
        refreshControl.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        timetableView.tableView.addSubview(refreshControl)
    }

    @objc fileprivate func refresh(_ sender: AnyObject) {
        timetableView.weekParity.selectedSegmentIndex = 0
        checkIfUserLoggedIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    fileprivate func checkIfSubjectsExist() {
        if timetableView.subjects.isEmpty {
            timetableView.tableView.alpha = 0
            timetableView.emptyView.alpha = 0.5
        } else {
            timetableView.tableView.alpha = 1
            timetableView.emptyView.alpha = 0
        }
    }
    
    @objc fileprivate func changedWeek(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 1:
            timetableView.subjects = [[Subject]]()
            for array in subjects {
                var newArray = [Subject]()
                for subject in array {
                    if subject.parity != "Четная" {
                        newArray.append(subject)
                    }
                }
                if !newArray.isEmpty {
                    timetableView.subjects.append(newArray)
                }
            }
            timetableView.tableView.reloadData()
            checkIfSubjectsExist()
        case 2:
            timetableView.subjects = [[Subject]]()
            for array in subjects {
                var newArray = [Subject]()
                for subject in array {
                    if subject.parity != "Нечетная" {
                        newArray.append(subject)
                    }
                }
                if !newArray.isEmpty {
                    timetableView.subjects.append(newArray)
                }
            }
            timetableView.tableView.reloadData()
            checkIfSubjectsExist()
        default:
            timetableView.subjects = subjects
            timetableView.tableView.reloadData()
            checkIfSubjectsExist()
        }
    }

    fileprivate func setupView() {
        timetableView.tableView.dataSource = self
        timetableView.tableView.delegate = self
        view.addSubview(timetableView)
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
        timetableView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    fileprivate func setupSpinner() {
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        UIApplication.shared.beginIgnoringInteractionEvents()
        spinner.startAnimating()
    }
    
    fileprivate func loadData() {
        ref = Database.database().reference()
        let university = user.university
        let group = user.group
        ref.child("universities").child(university).child("groups").child(group).child("schedule").observe(.value) { [weak self] (snapshot) in
            var weekdays = [String]()
            let dict = snapshot.value as? [String: AnyObject] ?? [:]
            for (key, _) in dict {
                weekdays.append(key)
            }
            weekdays.sort{ (self?.week.firstIndex(of: $0))! < (self?.week.firstIndex(of: $1))!}
            var _subjects = [[Subject]]()
            self?.ref = Database.database().reference().child("universities").child(university).child("groups").child(group).child("schedule")
            for day in weekdays {
                self?.ref.child(day).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                    var array = [Subject]()
                    for item in snapshot.children {
                        let subject = Subject(snapshot: item as! DataSnapshot)
                        array.append(subject)
                    }
                    array = array.sorted() { $0.date < $1.date}
                    _subjects.append(array)
                    self?.subjects = _subjects
                    self?.timetableView.subjects = _subjects
                    self?.timetableView.tableView.reloadData()
                    self?.checkIfSubjectsExist()
                })
            }
        }
    }
}

extension TimetableController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if user.isAdmin {
            let cell = tableView.cellForRow(at: indexPath) as! TimetableCell
            cell.showSwipe(.rightToLeft, animated: true)
        } else {
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timetableView.subjects.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetableView.subjects[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = timetableView.subjects[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TimetableCell.reuseId, for: indexPath) as! TimetableCell
        cell.subject = subject
        cell.selectionStyle = .none
        cell.swipeBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.delegate = self
        cell.rightSwipeSettings.transition = .border
        return cell
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        if !user.isAdmin { return nil }
        let indexPath = timetableView.tableView.indexPath(for: cell)!
        let subject = timetableView.subjects[indexPath.section][indexPath.row]
        if direction == .rightToLeft {
            return [
                MGSwipeButton(title: "Удалить", icon: #imageLiteral(resourceName: "delete"), backgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), callback: { (cell) -> Bool in
                    guard let newRef = subject.ref else { return true }
                    newRef.setValue(nil)
                    self.timetableView.tableView.beginUpdates()
                    if self.timetableView.subjects[indexPath.section].count == 1 {
                        self.timetableView.subjects.remove(at: indexPath.section)
                        let indexSet = NSMutableIndexSet()
                        indexSet.add(indexPath.section)
                        self.timetableView.tableView.deleteSections(indexSet as IndexSet, with: .automatic)
                    } else {
                        self.timetableView.subjects[indexPath.section].remove(at: indexPath.row)
                        self.timetableView.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    if self.subjects.count == 1 {
                        if self.subjects.count == 1 {
                            self.subjects = [[Subject]]()
                        }
                    }
                    self.timetableView.tableView.endUpdates()
                    self.checkIfSubjectsExist()
                    return true
                }),
                MGSwipeButton(title: "Изменить", icon: #imageLiteral(resourceName: "edit"), backgroundColor: .clear, callback: { (cell) -> Bool in
                    let addSubjectVC = AddSubjectController()
                    addSubjectVC.user = self.user
                    addSubjectVC.subject = subject
                    addSubjectVC.fromEdit = true
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(addSubjectVC, animated: true)
                    }
                    return true
                })
            ]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: UIFont().myFont(), size: 24)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = timetableView.subjects[section].first?.weekday ?? ""
        label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        return label
    }
}
