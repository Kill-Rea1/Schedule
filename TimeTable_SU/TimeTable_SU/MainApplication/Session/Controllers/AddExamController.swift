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
        setupView()
        addExamView.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        ref.removeAllObservers()
    }
    
    // MARK:- Fileprivate Methods
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
        addExamView.contentSize = CGSize(width: addExamView.frame.width, height: addExamView.frame.height + keyboardViewEndFrame.height)
        addExamView.scrollIndicatorInsets = addExamView.contentInset
    }
    
    @objc fileprivate func keyboardWillHide() {
        addExamView.contentSize = CGSize(width: addExamView.bounds.size.width, height: addExamView.bounds.size.height)
    }
    
    fileprivate func setupView() {
        view.addSubview(addExamView)
        addExamView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
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
        guard let exam = exam else {
            navigationItem.title = "Новый зачет"
            return
        }
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
