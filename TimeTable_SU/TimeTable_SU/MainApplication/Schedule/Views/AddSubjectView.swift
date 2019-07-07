//
//  AddSubjectView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class AddSubjectView: BaseScrollView {
    
    // MARK:- Properties
    
    public var weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
    public var types = ["Лекция", "Практика", "Семинар", "Лабораторная"]
    public var weekParities = ["Каждая", "Нечетная", "Четная"]
    public var selectedWeek = "Понедельник"
    public var selectedType = "Лекция"
    public var selectedParity = "Каждая"
    
    fileprivate var subject: Subject?
    
    // MARK:- Initialisation
    
    override func setupViews() {
        super.setupViews()
        addSubviews()
        addConstraints()
        putDelegatesAndDataSources()
        createToolBar()
        hideKeyboard()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK:- UIKit
    
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
        textField.tag = 3
        textField.inputView = time
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.text = formatter.string(from: time.date)
        textField.layer.cornerRadius = 8
        textField.tintColor = UIColor.clear
        let paddingViewSubject = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: textField.frame.height))
        textField.leftView = paddingViewSubject
        return textField
    }()
    
    fileprivate let endTimeLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Время окончания"
        return label
    }()
    
    public let endTimeTextField: MainTextField = {
        let textField = MainTextField()
        let time = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: "10:30") {
            time.date = date
        }
        time.datePickerMode = .time
        time.locale = Locale(identifier: "ru")
        time.addTarget(self, action: #selector(changeEndTime(datePicker:)), for: .valueChanged)
        textField.inputView = time
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.text = formatter.string(from: time.date)
        textField.layer.cornerRadius = 8
        textField.tintColor = UIColor.clear
        let paddingViewSubject = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: textField.frame.height))
        textField.leftView = paddingViewSubject
        return textField
    }()
    
    public let weekday: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    public let type: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    public let weekParity: MainSegmentedControl = {
        let items = ["Каждая неделя", "Нечетная неделя", "Четная неделя"]
        let segmented = MainSegmentedControl(items: items)
        segmented.addTarget(self, action: #selector(weekParityChanged(sender:)), for: .valueChanged)
        return segmented
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont().myFont(), size: 18)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 14
        return button
    }()
    
    // MARK:- Fileprivate Methods
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        startTimeTextField.inputAccessoryView = toolbar
        endTimeTextField.inputAccessoryView = toolbar
        subjectName.inputAccessoryView = toolbar
        classroom.inputAccessoryView = toolbar
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
    
    @objc fileprivate func changeEndTime(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        endTimeTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc fileprivate func weekParityChanged(sender: UISegmentedControl) {
        selectedParity = weekParities[sender.selectedSegmentIndex]
    }
    
    fileprivate func addConstraints() {
        subjectName.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, topAnchor, nil, .init(top: 20, left: 20, bottom: 0, right: 20), .init(width: 0, height: 40))
        classroom.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, subjectName.bottomAnchor, nil, .init(top: 20, left: 20, bottom: 0, right: 20), .init(width: 0, height: 40))
        startTimeLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, classroom.bottomAnchor, nil, .init(top: 20, left: 20, bottom: 0, right: 0), .init(width: 175, height: 30))
        startTimeTextField.addConstraints(nil, safeAreaLayoutGuide.trailingAnchor, classroom.bottomAnchor, nil, .init(top: 20, left: 0, bottom: 0, right: 20), .init(width: 65, height: 30))
        endTimeLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, startTimeLabel.bottomAnchor, nil, .init(top: 20, left: 20, bottom: 0, right: 0), .init(width: 200, height: 30))
        endTimeTextField.addConstraints(nil, safeAreaLayoutGuide.trailingAnchor, startTimeTextField.bottomAnchor, nil, .init(top: 20, left: 0, bottom: 0, right: 20), .init(width: 65, height: 30))
        weekday.addConstraints(safeAreaLayoutGuide.leadingAnchor, nil, endTimeLabel.bottomAnchor, nil, .init(top: 0, left: 20, bottom: 0, right: 0), .init(width: 175, height: 125))
        type.addConstraints(nil, safeAreaLayoutGuide.trailingAnchor, endTimeLabel.bottomAnchor, nil, .init(top: 0, left: 0, bottom: 0, right: 20), .init(width: 150, height: 125))
        weekParity.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, weekday.bottomAnchor, nil, .init(top: 0, left: 15, bottom: 0, right: 15), .init(width: 0, height: 40))
        saveButton.addConstraints(nil, nil, weekParity.bottomAnchor, bottomAnchor, .init(top: 50, left: 0, bottom: 50, right: 0), .init(width: 120, height: 50))
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    fileprivate func addSubviews() {
        addSubview(subjectName)
        addSubview(classroom)
        addSubview(weekday)
        addSubview(weekParity)
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(startTimeTextField)
        addSubview(endTimeTextField)
        addSubview(type)
        addSubview(saveButton)
    }
    
    fileprivate func putDelegatesAndDataSources() {
        type.delegate = self
        type.dataSource = self
        weekday.dataSource = self
        weekday.delegate = self
        subjectName.delegate = self
        classroom.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
    }
}

extension AddSubjectView: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK:- PickerView Settings
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case weekday:
            return weekdays.count
        default:
            return types.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = (view as? UILabel)
        if label == nil {
            label = UILabel()
            label?.font = UIFont(name: "Comfortaa", size: 20)
            label?.textAlignment = .center
        }
        
        switch pickerView {
        case weekday:
            label?.text = weekdays[row]
        default:
            label?.text = types[row]
        }
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case weekday:
            selectedWeek = weekdays[row]
        default:
            selectedType = types[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = ""
        switch pickerView {
        case weekday:
            title = weekdays[row]
        default:
            title = types[row]
        }
        let myTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        return myTitle
    }
}
