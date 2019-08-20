//
//  AddExamController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AddExamController: UIViewController {
    
    // MARK:- Properties
    
    fileprivate var ref: DatabaseReference!
    fileprivate let addExamView = AddExamView()
    public var user: UserDB!
    public var fromEdit = false
    public var exam: Exam?
    
    // MARK:- View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        ref = Database.database().reference()
        setupViewEdit()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleBack))
        setupView()
        addExamView.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.removeAllObservers()
    }
    
    // MARK:- Fileprivate Methods
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    @objc fileprivate func handleBack() {
        dismiss(animated: true)
    }
    
    fileprivate func setupView() {
        view.addSubview(addExamView)
        addExamView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, nil)
    }
    
    @objc fileprivate func handleSave() {
        guard let name = addExamView.subjectName.text, name != "" else { return }
        guard let classroom = addExamView.classroom.text, classroom != "" else { return }
        guard let date = addExamView.dateTextField.text, date != "" else { return }
        guard let time = addExamView.startTimeTextField.text, time != "" else { return }
        
        if fromEdit {
            guard let exam = exam else { return }
            let prevExamRef = exam.ref
            prevExamRef?.setValue(nil)
        }
        
        let newExam = Exam(name: name, classroom: classroom, date: date, time: time, type: addExamView.selectedType)
        let newExamRef = ref.child("universities").child(user.university).child("groups").child(user.group).child("session").childByAutoId()
        newExamRef.setValue(newExam.convertToDictionary())
        
        dismiss(animated: true)
    }
    
    fileprivate func setupViewEdit() {
        guard let exam = exam else {
            navigationItem.title = "Новый зачет"
            return
        }
        addExamView.subjectName.text = exam.name
        addExamView.classroom.text = exam.classroom
        addExamView.startTimeTextField.text = exam.time
        addExamView.dateTextField.text = exam.date
        addExamView.examType.selectedIndex = addExamView.types.firstIndex(of: exam.type) ?? 0
        addExamView.selectedType = exam.type
        addExamView.saveButton.setTitle("Сохранить", for: .normal)
        navigationItem.title = "Изменить \(exam.type)"
    }
}
