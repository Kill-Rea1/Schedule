//
//  EnterViewController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class EnterController: UIViewController {
    
    // MARK:- Properties

    fileprivate let enterView = EnterView()
    fileprivate var alertController: CustomAlertController!
    fileprivate let loginHud = JGProgressHUD(style: .dark)
    
    // MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        addTargets()
    }
    
    // MARK:- Private Methods
    
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
        loginHud.textLabel.text = "Выполняется вход.."
        loginHud.show(in: view)
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            self?.loginHud.dismiss()
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
