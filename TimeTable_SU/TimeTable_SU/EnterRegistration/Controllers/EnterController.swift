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
    fileprivate var alertController: CustomAlertController!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleShowKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - enterView.frame.origin.y - (enterView.frame.height - enterView.registerButton.frame.height)
        let difference = keyboardFrame.height - bottomSpace
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc fileprivate func handleHideKeyboard() {
        view.transform = .identity
    }
    
    fileprivate func addTargets() {
        enterView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        enterView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        enterView.resetPasswordButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
    }
    
    @objc func handleReset() {
        
        setupAlertController()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alertController.view.alpha = 1
        })
    }
    
    fileprivate func setupView() {
        view.addSubview(enterView)
        enterView.addConstraints(view.leadingAnchor, view.trailingAnchor, nil, nil)
        enterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupAlertController() {
        alertController = CustomAlertController()
        alertController.delegate = self
        alertController.view.alpha = 0
        alertController.titleLabel.text = "Введите почту"
        alertController.myTextView.text = "Почта"
        alertController.placeholderText = "Почта"
        view.addSubview(alertController.view)
        let window = UIApplication.shared.keyWindow
        alertController.view.frame = window?.frame ?? .zero
        addChild(alertController)
    }
    
    @objc fileprivate func handleDone() {
        guard let email = alertController.myTextView.text, email != "", email != "Почта" else {
            handleCancel()
            enterView.displayWarningLabel(withText: "Вы не ввели почту")
            return
        }
        handleCancel()
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if error != nil {
                self?.enterView.displayWarningLabel(withText: "Такой пользователь не найден")
            }
            self?.enterView.displayWarningLabel(withText: "Проверьте почту")
        }
    }
    
    @objc fileprivate func handleCancel() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alertController.view.alpha = 0
        }) { (_) in
            self.alertController.view.removeFromSuperview()
            self.alertController.removeFromParent()
        }
    }
    
    @objc fileprivate func handleRegister() {
        let navController = UINavigationController(rootViewController: RegistrationController())
        present(navController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        guard let email = enterView.emailTextField.text, let password = enterView.passwordTextField.text, email != "", password != "" else {
            enterView.displayWarningLabel(withText: "Данные не корректны")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.enterView.displayWarningLabel(withText: "Неправильный пароль")
                return
            }
            if user != nil {
                guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                navigationController.viewControllers = [MainController()]
                UserDefaults.standard.setIsLoggedIn(value: true)
                
                self?.dismiss(animated: true, completion: nil)
                return
            }
            self?.enterView.displayWarningLabel(withText: "Такой пользователь не найден")
        })
    }
}

extension EnterController: CustomAlertControllerDelegate {
    func didConfirm() {
        handleDone()
    }
    
    func didCancel() {
        handleCancel()
    }
}
