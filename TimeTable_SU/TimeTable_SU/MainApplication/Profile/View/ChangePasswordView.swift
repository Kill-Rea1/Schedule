//
//  ChangePasswordView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 08/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ChangePasswordView: BaseView {
    
    // MARK:- Properties
    
    fileprivate let spacing: CGFloat = 30
    fileprivate let padding: CGFloat = 20
    fileprivate let height: CGFloat = 50
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        configure()
        createToolBar()
        hideKeyboard()
    }
    
    // MARK:- UIKit
    
    public let currentPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Текущий пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    public let newPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Новый пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    public let newPasswordAgainTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Новый пароль еще раз"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    fileprivate let warningLabel: MainLabel = {
        let label = MainLabel()
        label.textColor = .red
        label.numberOfLines = 0
        label.text = "Warning"
        label.alpha = 0
        return label
    }()
    
    // MARK:- Fileprivate methods
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexibleButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        currentPasswordTextField.inputAccessoryView = toolbar
        newPasswordTextField.inputAccessoryView = toolbar
        newPasswordAgainTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
    
    public func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.warningLabel.alpha = 1
        }) { [weak self] (complete) in
            self?.warningLabel.alpha = 0
        }
    }
    
    fileprivate func configure() {
        addSubview(warningLabel)
        addSubview(currentPasswordTextField)
        addSubview(newPasswordTextField)
        addSubview(newPasswordAgainTextField)
        addSubview(saveButton)
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordAgainTextField.delegate = self
        warningLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, safeAreaLayoutGuide.topAnchor, nil, .init(top: 0, left: 0, bottom: 0, right: 0), .init(width: 0, height: 0))
        currentPasswordTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, warningLabel.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        newPasswordTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, currentPasswordTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        newPasswordAgainTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, newPasswordTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        saveButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, newPasswordAgainTextField.bottomAnchor, nil, .init(top: spacing * 2, left: padding * 4, bottom: 0, right: padding * 4), .init(width: 0, height: height))
    }
}

extension ChangePasswordView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
        saveButton.backgroundColor = .black
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentPasswordTextField.text == nil && newPasswordTextField.text == nil && newPasswordAgainTextField.text == nil {
            saveButton.backgroundColor = .lightGray
            saveButton.isEnabled = false
        }
    }
}
