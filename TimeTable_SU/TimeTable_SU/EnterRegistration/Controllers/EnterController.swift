//
//  EnterViewController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class EnterController: UIViewController {
    
    // MARK:- Properties

    fileprivate let enterView = EnterView()
    fileprivate let alertController = CustomAlertController()
    
    // MARK:- ViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        addTargets()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- Private Methods
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrameSize = view.convert(keyboardSize, from: view.window)
        enterView.contentSize = CGSize(width: enterView.contentSize.width, height: enterView.contentSize.height + keyboardFrameSize.height)
        enterView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        enterView.contentSize = CGSize(width: enterView.contentSize.width, height: enterView.contentSize.height - keyboardFrameSize.height)
        enterView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func addTargets() {
        enterView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        enterView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        enterView.resetPasswordButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
    }
    
    @objc func handleReset() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alertController.alpha = 1
        })
    }
    
    fileprivate func setupView() {
        view.addSubview(enterView)
        view.addSubview(alertController)
        setupAlertController()
        enterView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
        let window = UIApplication.shared.keyWindow
        alertController.frame = window?.frame ?? .zero
    }
    
    fileprivate func setupAlertController() {
        alertController.alpha = 0
        alertController.titleLabel.text = "Введите почту"
        alertController.myTextView.text = "Почта"
        alertController.confirmButton.setTitle("Готово", for: .normal)
        alertController.confirmButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        alertController.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDone() {
        guard let email = alertController.myTextView.text, email != "", email != "Почта" else {
            handleCancel()
            displayWarningLabel(withText: "Вы не ввели почту")
            return
        }
        handleCancel()
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Такой пользователь не найден")
            }
            self?.displayWarningLabel(withText: "Проверьте почту")
        }
    }
    
    @objc fileprivate func handleCancel() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alertController.alpha = 0
        })
    }
    
    @objc fileprivate func handleRegister() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    fileprivate func displayWarningLabel(withText text: String) {
        enterView.warningLabel.text = text
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.enterView.warningLabel.alpha = 1
        }) { [weak self] (complete) in
            self?.enterView.warningLabel.alpha = 0
        }
    }
    
    @objc fileprivate func handleLogin() {
        guard let email = enterView.emailTextField.text, let password = enterView.passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Данные не корректны")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Неправильный пароль")
                return
            }
            if user != nil {
                guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                navigationController.viewControllers = [MainController()]
                UserDefaults.standard.setIsLoggedIn(value: true)
                
                self?.dismiss(animated: true, completion: nil)
                return
            }
            self?.displayWarningLabel(withText: "Такой пользователь не найден")
        })
    }
}
