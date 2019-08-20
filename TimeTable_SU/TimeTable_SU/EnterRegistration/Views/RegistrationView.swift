//
//  UniGrView.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

extension RegistrationView: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.layer.borderColor = UIColor.black.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil {
            switch textField {
            case emailTextField:
                textField.placeholder = "Введите почту.."
            case passwordTextField:
                textField.placeholder = "Придумайте пароль.."
            default:
                textField.placeholder = "Введите имя.."
            }
        }
    }
}

class RegistrationView: BaseView {

    // MARK:- Properties
    
    fileprivate let height: CGFloat = 40
    fileprivate let padding: CGFloat = 20
    fileprivate let spacing: CGFloat = 20
    
    // MARK:- Initialisation

    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
        putDelegates()
        hideKeyboard()
        createToolBar()
        warningLabel.alpha = 0
    }
    
    // MARK:- UIKit
    
    fileprivate let adminImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "premium"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate let adminLabel: MainLabel = {
        let label = MainLabel()
        label.font = UIFont(name: Comfortaa.regular.rawValue, size: 24)
        label.text = "Вы будете админом!"
        return label
    }()
    
    lazy public var headerView: UIView = {
        let view = UIView()
        view.addSubview(adminLabel)
        view.addSubview(tipButton)
        view.addSubview(adminImageView)
        NSLayoutConstraint.activate([
            adminImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adminImageView.heightAnchor.constraint(equalToConstant: 40),
            adminImageView.widthAnchor.constraint(equalToConstant: 40),
            adminImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            adminLabel.leadingAnchor.constraint(equalTo: adminImageView.trailingAnchor, constant: 5),
            adminLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            adminLabel.heightAnchor.constraint(equalTo: adminImageView.heightAnchor),
            adminLabel.widthAnchor.constraint(equalToConstant: 280),
            tipButton.leadingAnchor.constraint(equalTo: adminLabel.trailingAnchor),
            tipButton.heightAnchor.constraint(equalToConstant: 20),
            tipButton.widthAnchor.constraint(equalToConstant: 20),
            tipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    public let emailTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .center
        textField.placeholder = "Введите почту.."
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    public let passwordTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .center
        textField.placeholder = "Придумайте пароль.."
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        if #available(iOS 12, *) {
            textField.textContentType = .oneTimeCode
        } else {
            textField.textContentType = .init(rawValue: "")
        }
        return textField
    }()
    
    public let nameTextField: MainTextField = {
        let textField = MainTextField()
        textField.textAlignment = .center
        textField.placeholder = "Введите имя.."
        textField.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        textField.autocorrectionType = .no
        return textField
    }()
    
    public let universityButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setTitle("Выберите ВУЗ", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.numberOfLines = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let groupButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setTitle("Выберите группу", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 18)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 14
        return button
    }()
    
    public let tipButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "tip"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let warningLabel = WarningLabel()
    
    // MARK:- Private Methods
    
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
    
    fileprivate func setup() {
        addSubview(warningLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(nameTextField)
        addSubview(universityButton)
        addSubview(groupButton)
        addSubview(registerButton)
        addSubview(headerView)
        
        headerView.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, topAnchor, nil, .init(top: 0, left: padding, bottom: 0, right: 0), .init(width: 0, height: 50))
        warningLabel.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, headerView.bottomAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: 0), .init(width: 0, height: height * 1.5))
        nameTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, warningLabel.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        emailTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, nameTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        passwordTextField.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, emailTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        universityButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, passwordTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        groupButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, universityButton.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        registerButton.addConstraints(safeAreaLayoutGuide.leadingAnchor, safeAreaLayoutGuide.trailingAnchor, groupButton.bottomAnchor, bottomAnchor, .init(top: spacing * 1.5, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
    }
    
    fileprivate func putDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
    }
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexibleButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
}
