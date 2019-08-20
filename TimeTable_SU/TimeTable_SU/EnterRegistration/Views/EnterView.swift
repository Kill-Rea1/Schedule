//
//  EnterView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

extension EnterView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil {
            switch textField {
            case emailTextField:
                textField.placeholder = "Введите почту.."
            default:
                textField.placeholder = "Введите пароль.."
            }
        }
    }
}

class EnterView: BaseScrollView {
    
    // MARK:- Properties
    
    fileprivate let height: CGFloat = 40
    fileprivate let padding: CGFloat = 20
    fileprivate let spacing: CGFloat = 20
    
    override func setupViews() {
        super.setupViews()
        addSubviews()
        addConstraints()
        putDelegates()
        createToolBar()
        hideKeyboard()
        warningLabel.alpha = 0
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK:- UIKit
    
    fileprivate let titleLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 40)
        label.text = "Расписание"
        return label
    }()
    
    public let emailTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .center
        textField.placeholder = "Введите почту.."
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()

    public let passwordTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .center
        textField.placeholder = "Введите пароль.."
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()

    public let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 14
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 18)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 14
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 18)
        button.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let warningLabel = WarningLabel()
    
    public let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыл пароль", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 14)
        return button
    }()
    
    // MARK:- Fileprivate Methods
    
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

    fileprivate func addSubviews() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(resetPasswordButton)
        addSubview(loginButton)
        addSubview(registerButton)
        addSubview(warningLabel)
    }

    fileprivate func addConstraints() {
        
        titleLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, topAnchor, nil, .init(top: 40, left: 0, bottom: 0, right: 0), .init(width: 0, height: 100))
        warningLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, titleLabel.bottomAnchor, nil, .init(top: spacing, left: 0, bottom: 0, right: 0), .init(width: 0, height: 50))
        emailTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, warningLabel.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        passwordTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, emailTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        resetPasswordButton.addConstraints(centerXAnchor, safeAreaLayoutGuide.trailingAnchor, passwordTextField.bottomAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: padding), .init(width: 0, height: 20))
        loginButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, passwordTextField.bottomAnchor, nil, .init(top: 50, left: padding * 4, bottom: 0, right: padding * 4), .init(width: 0, height: height))
        registerButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, loginButton.bottomAnchor, bottomAnchor, .init(top: spacing, left: padding * 4, bottom: height, right: padding * 4), .init(width: 0, height: height))
    }

    fileprivate func putDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
}
