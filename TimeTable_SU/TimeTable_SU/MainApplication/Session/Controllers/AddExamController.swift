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
    
    fileprivate var ref: DatabaseReference!
    fileprivate let addExamView = AddExamView()
    public var user: UserDB!
    public var fromEdit = false
    public var exam: Exam?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        ref = Database.database().reference()
        if fromEdit {
            setupViewEdit()
        } else {
            navigationItem.title = "Добавить зачет"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        setupView()
        addExamView.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    fileprivate func setupView() {
        view.addSubview(addExamView)
        addExamView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
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
        
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    fileprivate func setupViewEdit() {
        guard let exam = exam else { return }
        addExamView.subjectName.text = exam.name
        addExamView.classroom.text = exam.classroom
        addExamView.startTimeTextField.text = exam.time
        addExamView.dateTextField.text = exam.date
        addExamView.examType.selectedSegmentIndex = addExamView.types.firstIndex(of: exam.type)!
        addExamView.selectedType = exam.type
        addExamView.saveButton.setTitle("Сохранить", for: .normal)
        navigationItem.title = "Изменить \(exam.type)"
    }
}
