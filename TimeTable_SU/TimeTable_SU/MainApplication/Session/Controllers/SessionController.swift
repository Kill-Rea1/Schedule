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

class SessionController: UIViewController, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
    fileprivate var ref: DatabaseReference!
    fileprivate var exams = [Exam]()
    public var user: UserDB!
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupNavigationItem()
        loadExams()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    fileprivate func setupNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сессия"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(handleAdd))
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? MainNavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    @objc fileprivate func handleAdd() {
        guard let user = user else { return }
        let addExamVC = AddExamController()
        addExamVC.user = user
        guard let mainNavigationController = UIApplication.shared.keyWindow?.rootViewController as? MainNavigationController else { return }
        (mainNavigationController.viewControllers.first as? MainController)?.navigate(to: addExamVC)
    }
    
    @objc fileprivate func handleRefresh() {
        loadExams()
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
        }
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor, .init(top: 100, left: 10, bottom: 0, right: 10))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(ExamTableCell.self, forCellReuseIdentifier: ExamTableCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
    }

    // MARK: - Table view data source

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
        let cell = tableView.cellForRow(at: indexPath) as! ExamTableCell
        cell.showSwipe(.rightToLeft, animated: true)
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
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
                    guard let mainNavigationController = UIApplication.shared.keyWindow?.rootViewController as? MainNavigationController else { return true }
                    (mainNavigationController.viewControllers.first as? MainController)?.navigate(to: addExamVC)
                    return true
                })
            ]
        } else {
            return nil
        }
    }
}
