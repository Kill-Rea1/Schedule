//
//  ChangePasswordController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 08/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordController: UIViewController {
    
    fileprivate let spacing: CGFloat = 30
    fileprivate let padding: CGFloat = 20
    fileprivate let height: CGFloat = 50
    
    fileprivate let currentPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Текущий пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    fileprivate let newPasswordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Новый пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    fileprivate let newPasswordAgainTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Новый пароль еще раз"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: UIFont().myFont(), size: 20)
        return textField
    }()
    
    fileprivate let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleUpdatePassword), for: .touchUpInside)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupViews()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сменить пароль"
    }
    
    fileprivate func setupViews() {
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(newPasswordAgainTextField)
        view.addSubview(saveButton)
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordAgainTextField.delegate = self
        currentPasswordTextField.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        newPasswordTextField.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, currentPasswordTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        newPasswordAgainTextField.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, newPasswordTextField.bottomAnchor, nil, .init(top: spacing, left: padding, bottom: 0, right: padding), .init(width: 0, height: height))
        saveButton.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, newPasswordAgainTextField.bottomAnchor, nil, .init(top: spacing * 2, left: padding * 4, bottom: 0, right: padding * 4), .init(width: 0, height: height))
        
    }
    
    @objc fileprivate func handleUpdatePassword() {
        view.endEditing(true)
        guard let currentPassword = currentPasswordTextField.text, currentPassword != "" else { return }
        guard let newPassword = newPasswordTextField.text, newPassword != "" else { return }
        guard let newPasswordAgain = newPasswordAgainTextField.text, newPasswordAgain != "" else { return }
        
        if newPasswordAgain == newPassword {
            guard let user = Auth.auth().currentUser else { return }
            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
            user.reauthenticate(with: credential) { (_, error) in
                if error == nil {
                    user.updatePassword(to: newPassword, completion: { [weak self] (error) in
                        if error == nil {
                            self?.navigationController?.popViewController(animated: true)
                        } else {
                            print(error)
                        }
                    })
                } else {
                    print(error)
                }
            }
        }
    }
}

extension ChangePasswordController: UITextFieldDelegate {
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
