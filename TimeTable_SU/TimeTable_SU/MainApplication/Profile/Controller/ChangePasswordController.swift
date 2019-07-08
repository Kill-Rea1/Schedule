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
    
    // MARK:- Properties
    
    fileprivate let changePasswordView = ChangePasswordView()
    
    // MARK:- View Controller method

    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordView.saveButton.addTarget(self, action: #selector(handleUpdatePassword), for: .touchUpInside)
        setupViews()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сменить пароль"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .done, target: self, action: #selector(handleBack))
        navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK:- Fileprivate methods
    
    @objc fileprivate func handleBack() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupViews() {
        view.addSubview(changePasswordView)
        changePasswordView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
    }
    
    @objc fileprivate func handleUpdatePassword() {
        view.endEditing(true)
        guard let currentPassword = changePasswordView.currentPasswordTextField.text, currentPassword != "" else { changePasswordView.displayWarningLabel(withText: "Вы не ввели старый пароль"); return }
        guard let newPassword = changePasswordView.newPasswordTextField.text, newPassword != "" else { changePasswordView.displayWarningLabel(withText: "Вы не ввели новый пароль"); return }
        guard let newPasswordAgain = changePasswordView.newPasswordAgainTextField.text, newPasswordAgain != "" else { changePasswordView.displayWarningLabel(withText: "Вы не повторили пароль"); return }
        if newPassword.count < 6 || newPasswordAgain.count < 6 {
            changePasswordView.displayWarningLabel(withText: "Короткий пароль. Минимум 6 символов"); return
        }
        if newPasswordAgain == newPassword {
            guard let user = Auth.auth().currentUser else { return }
            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
            user.reauthenticate(with: credential) { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    user.updatePassword(to: newPassword, completion: { [weak self] (error) in
                        if error == nil {
                            self?.dismiss(animated: true, completion: nil)
                        } else {
                            self?.changePasswordView.displayWarningLabel(withText: "Неправильный пароль")
                        }
                    })
                }
            }
        } else {
            changePasswordView.displayWarningLabel(withText: "Пароли не совпадают")
        }
    }
}
