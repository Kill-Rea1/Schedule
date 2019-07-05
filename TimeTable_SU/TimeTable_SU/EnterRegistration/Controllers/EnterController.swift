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
    
    // MARK:- ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        enterView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        enterView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = .red
    }
    
    // MARK:- Private Methods
    
    fileprivate func setupView() {
        view.addSubview(enterView)
        enterView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
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
