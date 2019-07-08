//
//  SessionController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class SessionController: UIViewController, MGSwipeTableCellDelegate {
    
    // MARK:- Properties
    
    fileprivate var ref: DatabaseReference!
    fileprivate var exams = [Exam]()
    fileprivate var user: UserDB! {
        willSet {
            if newValue.isAdmin {
                let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(handleAdd))
                let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh))
                navigationItem.rightBarButtonItems = [addButton, refreshButton]
            } else {
                let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh))
                navigationItem.rightBarButtonItems = [refreshButton]
            }
        }
    }
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "noSchedule")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let backgroundLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Нет сессии"
        label.font = UIFont(name: UIFont().myFont(), size: 35)
        return label
    }()
    
    fileprivate let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.alpha = 0.5
        return view
    }()
    
    // MARK:- View Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user != nil {
            loadExams()
        }
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.isAddControllerOpened = false
    }
    
    override func viewDidLoad() {
        loadUser()
        tableView.alpha = 0
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupNavigationItem()
        setupTableView()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    // MARK:- Fileprivate Methods
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Сессия"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(handleAdd))
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    @objc fileprivate func handleAdd() {
        guard let user = user else { return }
        let addExamVC = AddExamController()
        addExamVC.user = user
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.isAddControllerOpened = true
        if let navigationController = navigationController {
            navigationController.pushViewController(addExamVC, animated: true)
        }
    }
    
    @objc fileprivate func handleRefresh() {
        loadExams()
    }
    
    fileprivate func checkIfExamsExist() {
        if exams.isEmpty {
            tableView.alpha = 0
            backgroundView.alpha = 0.5
        } else {
            tableView.alpha = 1
            backgroundView.alpha = 0
        }
    }
    
    fileprivate func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            let user = UserDB(snapshot: snapshot)
            self?.user = user
            self?.loadExams()
        }
    }
    
    fileprivate func loadExams() {
        ref = Database.database().reference().child("universities").child(user.university).child("groups").child(user.group).child("session")
        ref.observe(.value) { [weak self] (snapshot) in
            var _exams = [Exam]()
            for item in snapshot.children {
                let exam = Exam(snapshot: item as! DataSnapshot)
                _exams.append(exam)
            }
            _exams = _exams.sorted { $0.dateType < $1.dateType }
            self?.exams = _exams
            self?.tableView.reloadData()
            self?.checkIfExamsExist()
        }
    }
    
    fileprivate func setupViews() {
        view.addSubview(tableView)
        view.addSubview(backgroundView)
        backgroundView.addSubview(backgroundLabel)
        backgroundView.addSubview(backgroundImage)
        backgroundView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
        backgroundImage.addConstraints(nil, nil, backgroundView.topAnchor, nil, .init(top: 20, left: 0, bottom: 0, right: 0), .init(width: 150, height: 150))
        backgroundImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundLabel.addConstraints(backgroundView.leadingAnchor, backgroundView.trailingAnchor, backgroundImage.bottomAnchor, nil, .init(top: 30, left: 0, bottom: 0, right: 0), .init(width: 0, height: 55))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor, .init(top: 20, left: 10, bottom: 0, right: 10))
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(ExamTableCell.self, forCellReuseIdentifier: ExamTableCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
    }
}

extension SessionController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exams.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exam = exams[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: ExamTableCell.reuseId, for: indexPath) as! ExamTableCell
        cell.nameLabel.text = exam.name
        cell.classroomLabel.text = exam.classroom + "ауд"
        cell.typeLabel.text = exam.type
        cell.timeLabel.text = exam.time
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 14
        cell.clipsToBounds = true
        cell.swipeBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.delegate = self
        cell.rightSwipeSettings.transition = .border
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "Comfortaa", size: 30)
        label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        label.text = exams[section].date
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if user.isAdmin {
            let cell = tableView.cellForRow(at: indexPath) as! ExamTableCell
            cell.showSwipe(.rightToLeft, animated: true)
        }
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        if !user.isAdmin { return nil }
        let indexPath = tableView.indexPath(for: cell)!
        let exam = exams[indexPath.section]
        if direction == .rightToLeft {
            return [
                MGSwipeButton(title: "Удалить", icon: #imageLiteral(resourceName: "delete"), backgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), callback: { (cell) -> Bool in
                    guard let newRef = exam.ref else { return true }
                    newRef.setValue(nil)
                    self.tableView.beginUpdates()
                    self.exams.remove(at: indexPath.section)
                    self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
                    self.tableView.endUpdates()
                    return true
                }),
                MGSwipeButton(title: "Изменить", icon: #imageLiteral(resourceName: "edit"), backgroundColor: .clear, callback: { (cell) -> Bool in
                    let addExamVC = AddExamController()
                    addExamVC.user = self.user
                    addExamVC.exam = exam
                    addExamVC.fromEdit = true
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(addExamVC, animated: true)
                    }
                    return true
                })
            ]
        } else {
            return nil
        }
    }
}
