//
//  UniGrViewController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK:- Properties
    fileprivate var ref: DatabaseReference!
    public var isAdmin = false {
        willSet {
            registerView.headerView.isHidden = !newValue
        }
    }
    lazy fileprivate var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.isHidden = true
        view.layer.cornerRadius = 40
        view.addSubview(doneButton)
        view.addSubview(tipTextView)
        tipTextView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, doneButton.topAnchor, .init(top: 20, left: 20, bottom: 0, right: 20))
        doneButton.addConstraints(view.leadingAnchor, view.trailingAnchor, nil, view.bottomAnchor, .init(), .init(width: 0, height: 25))
        return view
    }()
    
    fileprivate let tipTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Только админы расписания могут изменять его"
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont(name: "Comfortaa", size: 16)
        return textView
    }()
    
    fileprivate let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Понятно!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfrotaa", size: 28)
        button.backgroundColor = .clear
//        button.layer.cornerRadius = 14
        return button
    }()
    fileprivate let registerView = RegistrationView()
    public var university: String? {
        willSet {
            guard let university = newValue else {
                registerView.universityButton.setTitle("Выберите ВУЗ", for: .normal)
                registerView.groupButton.isEnabled = false
                registerView.groupButton.alpha = 0.5
                return
            }
            registerView.universityButton.setTitle(university, for: .normal)
            registerView.groupButton.setTitle("Выберите группу", for: .normal)
            registerView.groupButton.isEnabled = true
            registerView.groupButton.alpha = 1
        }
    }
    public var group: University! {
        willSet {
            guard let group = newValue else {
                registerView.groupButton.setTitle("Выберите группу", for: .normal)
                return
            }
            registerView.groupButton.setTitle("Группа: \(group.name)", for: .normal)
        }
    }
    public var isMovedFromSearching = false {
        willSet {
            if newValue {
                registerView.notFoundButton.isHidden = false
            } else {
                registerView.notFoundButton.isHidden = true
            }
        }
    }
    
    // MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setup()
        setupActions()
    }
    
    // MARK:- Private Methods
    
    @objc fileprivate func handleHide() {
        registerView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tipView.alpha = 0
        }) { (true) in
            self.tipView.isHidden = true
        }
    }
    
    @objc fileprivate func handleShow() {
        registerView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.tipView.isHidden = false
            self.tipView.alpha = 1
        })
    }
    
    fileprivate func setup() {
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Регистрация"
        view.addSubview(registerView)
        view.addSubview(tipView)
        registerView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
        tipView.addSize(to: .init(width: 200, height: 150))
        tipView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tipView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        NSLayoutConstraint.activate([
//            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            registerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            registerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tipView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tipView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            tipView.widthAnchor.constraint(equalToConstant: 200),
//            tipView.heightAnchor.constraint(equalToConstant: 150)
//            ])
        registerView.groupButton.isEnabled = false
        registerView.groupButton.alpha = 0.5
    }
    
    fileprivate func setupActions() {
        registerView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        registerView.universityButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        registerView.groupButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        registerView.notFoundButton.addTarget(self, action: #selector(handleFound), for: .touchUpInside)
        registerView.tipButton.addTarget(self, action: #selector(handleShow), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(handleHide), for: .touchUpInside)
    }
    
    fileprivate func displayWarningLabel(withText text: String) {
        registerView.warningLabel.text = text
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.registerView.warningLabel.alpha = 1
        }) { [weak self] (complete) in
            self?.registerView.warningLabel.alpha = 0
        }
    }
    
    @objc fileprivate func handleFound() {
        let alerController = UIAlertController(title: "Введите университет и группу", message: "", preferredStyle: .alert)
        let addAction: UIAlertAction!
        if university == nil {
            alerController.addTextField { (textField) in
                textField.textAlignment = .left
                textField.placeholder = "Введите университет"
                textField.font = UIFont(name: "Comfortaa", size: 16)
                textField.autocorrectionType = .no
            }
            alerController.addTextField { (textField) in
                textField.placeholder = "Введите группу"
                textField.textAlignment = .left
                textField.font = UIFont(name: "Comfortaa", size: 16)
                textField.autocorrectionType = .no
            }
            addAction = UIAlertAction(title: "Добавить", style: .default, handler: { [weak self] (action) in
                guard let university = alerController.textFields![0].text else { return }
                guard let group = alerController.textFields![1].text else { return }
                
                if !university.isEmpty && !group.isEmpty {
                    let newUniversity = University(name: university)
                    self?.university = newUniversity.name
                    let newGroup = University(name: group)
                    self?.group = newGroup
                    self?.registerView.notFoundButton.isHidden = true
                    self?.isAdmin = true
                    self?.ref.child("universities").child(newUniversity.name).setValue(["name" :newUniversity.name])
                    self?.ref.child("universities").child(newUniversity.name).child("groups").child(newGroup.name).setValue(["name": newGroup.name])
//                    self?.registerView.headerView.isHidden = false
                }
            })
        } else {
            alerController.addTextField { (textField) in
                textField.placeholder = "Введите группу"
                textField.textAlignment = .left
                textField.font = UIFont(name: "Comfortaa", size: 16)
                textField.autocorrectionType = .no
            }
            addAction = UIAlertAction(title: "Добавить", style: .default, handler: { [weak self] (action) in
                guard let group = alerController.textFields![0].text else { return }
                if !group.isEmpty {
                    self?.registerView.notFoundButton.isHidden = true
                    let newGroup = University(name: group)
                    self?.group = newGroup
                    self?.isAdmin = true
                    self?.ref.child("universities").child((self?.university!)!).child("groups").child(newGroup.name).setValue(["name": newGroup.name])
//                    self?.registerView.headerView.isHidden = false
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alerController.addAction(addAction)
        alerController.addAction(cancelAction)
        present(alerController, animated: true)
    }
    
    @objc fileprivate func handleSearch(sender: UIButton) {
        let searchController = SearchController()
        searchController.prevVC = self
        switch sender {
        case registerView.universityButton:
            searchController.isGroupSearching = false
            searchController.isUniversitySearching = true
        default:
            searchController.isGroupSearching = true
            searchController.isUniversitySearching = false
            searchController.selectedUniversity = university
        }
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc fileprivate func handleRegister() {
        guard let name = registerView.nameTextField.text, name != "" else {
            registerView.nameTextField.layer.borderColor = UIColor.red.cgColor
            displayWarningLabel(withText: "Вы не ввели имя")
            return
        }
        guard let email = registerView.emailTextField.text, email != "" else {
            registerView.emailTextField.layer.borderColor = UIColor.red.cgColor
            displayWarningLabel(withText: "Вы не ввели почту")
            return
        }
        guard let password = registerView.passwordTextField.text, password != "" else {
            registerView.passwordTextField.layer.borderColor = UIColor.red.cgColor
            displayWarningLabel(withText: "Вы не ввели пароль")
            return
        }
        if password.count < 6 {
            registerView.passwordTextField.layer.borderColor = UIColor.red.cgColor
            displayWarningLabel(withText: "Короткий пароль. Минимум 6 символов")
            return
        }
        guard let university = university else {
            displayWarningLabel(withText: "Вы не выбрали университет")
            return
        }
        guard let group = group else {
            displayWarningLabel(withText: "Вы не выбрали группу")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (res, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Пользователь уже существует")
                return
            }
            
            guard let uid = res?.user.uid else { return }
            self?.ref = Database.database().reference()
            var userRef = self?.ref.child("users").child(uid)
            let newUser = UserDB(uid: uid, email: email, name: name, university: university, group: group.name, isAdmin: self!.isAdmin)
            var values = newUser.convertToDictionary()
            userRef?.setValue(values)
            userRef = Database.database().reference().child("universities").child(university).child("groups").child(group.name).child("students").child(uid)
            values = ["uid": uid,"name": newUser.name, "email": email, "isAdmin": newUser.isAdmin]
            userRef?.setValue(values)
            let rootController = UIApplication.shared.keyWindow?.rootViewController
            guard let mainNavigationController = rootController as? MainNavigationController else { return }
            mainNavigationController.viewControllers = [MainController()]
            UserDefaults.standard.setIsLoggedIn(value: true)
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
