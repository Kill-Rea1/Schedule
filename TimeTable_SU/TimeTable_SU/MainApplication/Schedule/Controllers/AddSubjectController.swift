//
//  SecondViewController.swift
//  Timetable
//
//  Created by Кирилл Иванов on 05/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AddSubjectController: UIViewController {
    
    // MARK:- Properties
    
    public var subject: Subject?
    public var user: UserDB!
    public var fromEdit = false
    fileprivate var ref: DatabaseReference!
    fileprivate let addSubjectView = AddSubjectView()
    
    // MARK:- ViewController Methods
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubjectView.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        setupView()
        let university = user.university
        let group = user.group
        ref = Database.database().reference().child("universities").child(university).child("groups").child(group).child("schedule")
        if subject != nil {
            editingView()
        } else {
            navigationItem.title = "Новый предмет"
        }
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
    }
    
    // MARK:- Private Methods

    @objc fileprivate func save() {
        guard let name = addSubjectView.subjectName.text, name != "" else {
            let alertController = UIAlertController(title: "Ошибка", message: "Вы не ввели название предмета", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alertController, animated: true)
            return
        }
        guard let classNumber = addSubjectView.classroom.text, classNumber != "" else {
            let alertController = UIAlertController(title: "Ошибка", message: "Вы не ввели аудиторию", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alertController, animated: true)
            return
        }
        guard let start = addSubjectView.startTimeTextField.text, start != "" else { return }
        guard let end = addSubjectView.endTimeTextField.text, end != "" else { return }

        let newSubject = Subject(subjectName: name, startTime: start, endTime: end, classroom: classNumber, weekday: addSubjectView.selectedWeek, parity: addSubjectView.selectedParity, subjectType: addSubjectView.selectedType)

        if fromEdit {
            guard let subject = subject else { return }
            guard let subjectRef = subject.ref else { return }
            subjectRef.setValue(nil)
        }
        let subjectRef = self.ref.child(newSubject.weekday).childByAutoId()
        subjectRef.setValue(newSubject.convertToDictionary())

        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }

    fileprivate func setupView() {
        view.addSubview(addSubjectView)
        // AddSubjectView constraints
        addSubjectView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    fileprivate func editingView() {
        guard let subject = subject else { return }
        addSubjectView.subjectName.text = subject.subjectName
        addSubjectView.classroom.text = subject.classroom
        addSubjectView.startTimeTextField.text = subject.startTime
        addSubjectView.endTimeTextField.text = subject.endTime
        addSubjectView.weekday.selectRow(addSubjectView.weekdays.firstIndex(of: subject.weekday.capitalized)!, inComponent: 0, animated: true)
        addSubjectView.type.selectRow(addSubjectView.types.firstIndex(of: subject.subjectType.capitalized)!, inComponent: 0, animated: true)
        addSubjectView.weekParity.selectedSegmentIndex = addSubjectView.weekParities.firstIndex(of: subject.parity.capitalized)!
        fromEdit = true
        addSubjectView.saveButton.setTitle("Сохранить", for: .normal)
        addSubjectView.selectedParity = subject.parity.capitalized
        addSubjectView.selectedWeek = subject.weekday.capitalized
        navigationItem.title = "Изменить предмет"
    }
}
