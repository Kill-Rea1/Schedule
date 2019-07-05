//
//  AddExamView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class AddExamView: BaseView, UITextFieldDelegate {
    
    fileprivate let spacing: CGFloat = 20
    fileprivate let padding: CGFloat = 20
    public var selectedType = "Зачет"
    public let types =  ["Зачет", "Дифф. Зачет", "Экзамен"]

    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
        createToolBar()
        subjectName.delegate = self
        classroom.delegate = self
        startTimeTextField.delegate = self
    }
    
    public let subjectName: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Введите название предмета.."
        return textField
    }()
    
    public let classroom: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Введите аудиторию.."
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate let startTimeLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Время начала"
        return label
    }()
    
    public let startTimeTextField: MainTextField = {
        let textField = MainTextField()
        let time = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: "9:00") {
            time.date = date
        }
        time.datePickerMode = .time
        time.locale = Locale(identifier: "ru")
        time.addTarget(self, action: #selector(changeStartTime(datePicker:)), for: .valueChanged)
        textField.inputView = time
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.text = formatter.string(from: time.date)
        textField.layer.cornerRadius = 8
        textField.tintColor = UIColor.clear
        return textField
    }()
    
    let dateLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Дата"
        return label
    }()
    
    let dateTextField: MainTextField = {
        let textField = MainTextField()
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.locale = Locale(identifier: "ru")
        date.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        textField.placeholder = "Выберите дату..."
        textField.inputView = date
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.font = UIFont(name: "Comfortaa", size: 16)
        textField.tintColor = UIColor.clear
        return textField
    }()
    
    public let examType: MainSegmentedControl = {
        let items = ["Зачет", "Дифф. Зачет", "Экзамен"]
        let segmented = MainSegmentedControl(items: items)
        segmented.addTarget(self, action: #selector(examTypeChanged(sender:)), for: .valueChanged)
        return segmented
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 18)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 14
        return button
    }()
    
    @objc fileprivate func examTypeChanged(sender: UISegmentedControl) {
        selectedType = types[sender.selectedSegmentIndex]
    }
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexibleButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        startTimeTextField.inputAccessoryView = toolbar
        subjectName.inputAccessoryView = toolbar
        classroom.inputAccessoryView = toolbar
        dateTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc fileprivate func changeStartTime(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        startTimeTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc fileprivate func dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    fileprivate func addSubviews() {
        addSubview(subjectName)
        addSubview(classroom)
        addSubview(startTimeLabel)
        addSubview(startTimeTextField)
        addSubview(saveButton)
        addSubview(dateTextField)
        addSubview(dateLabel)
        addSubview(examType)
    }
    
    fileprivate func addConstraints() {
        subjectName.addConstraints(leadingAnchor, trailingAnchor, topAnchor, nil, .init(top: spacing * 4, left: padding, bottom: 0, right: padding), .init(width: 0, height: 40))
        classroom.addConstraints(leadingAnchor, trailingAnchor, subjectName.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: 40))
        startTimeLabel.addConstraints(leadingAnchor, nil, classroom.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: 0), .init(width: 175, height: 30))
        startTimeTextField.addConstraints(nil, trailingAnchor, classroom.bottomAnchor, nil, .init(top: spacing, left: 0, bottom: 0, right: padding), .init(width: 65, height: 30))
        dateLabel.addConstraints(leadingAnchor, centerXAnchor, startTimeLabel.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: 0), .init(width: 0, height: 40))
        dateTextField.addConstraints(centerXAnchor, trailingAnchor, startTimeTextField.bottomAnchor, nil, .init(top: spacing, left: 0, bottom: 0, right: padding), .init(width: 0, height: 40))
        examType.addConstraints(leadingAnchor, trailingAnchor, dateTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: 40))
        saveButton.addConstraints(nil, nil, examType.bottomAnchor, nil, .init(top: spacing * 3, left: 0, bottom: 0, right: 0), .init(width: 120, height: 50))
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
//        // Subject name constaints
//        subjectName.topAnchor.constraint(equalTo: topAnchor, constant: spacing * 4).isActive = true
//        subjectName.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        subjectName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        subjectName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
//        
//        // Classrom constraints
//        classroom.topAnchor.constraint(equalTo: subjectName.bottomAnchor, constant: spacing).isActive = true
//        classroom.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        classroom.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        classroom.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
//        
//        // Start time label constraints
//        startTimeLabel.topAnchor.constraint(equalTo: classroom.bottomAnchor, constant: spacing).isActive = true
//        startTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        startTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        startTimeLabel.widthAnchor.constraint(equalToConstant: 175).isActive = true
//        
//        // Start time text field constraints
//        startTimeTextField.topAnchor.constraint(equalTo: classroom.bottomAnchor, constant: spacing).isActive = true
//        startTimeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        startTimeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
//        startTimeTextField.widthAnchor.constraint(equalToConstant: 65).isActive = true
//        
//        dateLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: spacing).isActive = true
//        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        dateLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        dateTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: spacing).isActive = true
//        dateTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        dateTextField.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        dateTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
//        
//        examType.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: spacing).isActive = true
//        examType.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        examType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
//        examType.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        // Save button constraints
//        saveButton.topAnchor.constraint(equalTo: examType.bottomAnchor, constant: spacing * 3).isActive = true
//        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        saveButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
