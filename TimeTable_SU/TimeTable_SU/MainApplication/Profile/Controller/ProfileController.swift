//
//  ProfileViewController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    // MARK:- Properties
    
    let cellId = "cellId"
    
    fileprivate let profileView = ProfileView()
    public var user: UserDB! {
        willSet {
            profileView.nameTextField.text = newValue.name
            self.university = newValue.university
            self.group = newValue.group
            profileView.emailTextField.text = newValue.email
            self.isAdmin = newValue.isAdmin
        }
    }
    public var university: String! {
        willSet {
            profileView.universityLabel.text = newValue
            if self.university != newValue {
                profileView.groupLabel.text = "Выберете группу"
            } else {
            }
        }
    }
    public var group: String! {
        willSet {
            profileView.groupLabel.text = "Группа \(newValue ?? "")"
        }
    }
    public var isAdmin: Bool! {
        willSet {
            profileView.adminImageView.isHidden = !newValue
        }
    }
    
    // MARK:- View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupNavigationItem()
        addTargets()
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- Fileprivate Methods
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notofication: Notification) {
        guard let userInfo = notofication.userInfo else { return }
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        profileView.contentSize = CGSize(width: profileView.frame.width, height: profileView.frame.height + keyboardFrameSize.height)
        profileView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
    }
    
    @objc fileprivate func keyboardWillHide() {
        profileView.contentSize = CGSize(width: profileView.frame.width, height: profileView.frame.height)
    }
    
    fileprivate func addTargets() {
        profileView.nameChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.universityChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.groupChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.emailChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    @objc fileprivate func handleButtonTapped(sender: UIButton) {
        switch sender {
        case profileView.nameChangeButton:
            profileView.nameTextField.isEnabled = true
            profileView.nameTextField.layer.borderWidth = 1
            profileView.nameTextField.becomeFirstResponder()
        case profileView.emailChangeButton:
            profileView.emailTextField.isEnabled = true
            profileView.emailTextField.layer.borderWidth = 1
            profileView.emailTextField.becomeFirstResponder()
        default:
            handleSearch(sender: sender)
        }
    }
    
    fileprivate func handleSearch(sender: UIButton) {
        let searchController = SearchController()
        searchController.prevVC = self
        switch sender {
        case profileView.universityChangeButton:
            searchController.prevData = user.university
            searchController.isGroupSearching = false
            searchController.isUniversitySearching = true
        default:
            searchController.prevData = user.group
            searchController.isGroupSearching = true
            searchController.isUniversitySearching = false
            searchController.selectedUniversity = university
        }
        present(searchController, animated: true)
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Профиль"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc fileprivate func handleSave() {
        guard let name = profileView.nameTextField.text, name != "" else {
            return
        }
        guard let email = profileView.emailTextField.text, email != "" else {
            return
        }
        guard let university = university else {
            return
        }
        guard let group = group, group != "Выберете группу" else {
            return
        }
        
        guard let isAdmin = isAdmin else {
            return
        }
        
        let newUser = UserDB(uid: user.uid, email: email, name: name, university: university, group: group, isAdmin: isAdmin)
        var newUserRef = user.ref
        newUserRef?.setValue(newUser.convertToDictionary())
        newUserRef = Database.database().reference().child("universities").child(university).child("groups").child(group).child("students").child(newUser.uid)
        newUserRef?.updateChildValues(["name": newUser.name, "uid": newUser.uid, "email": newUser.email, "isAdmin": isAdmin])
        newUserRef? = Database.database().reference().child("universities").child(user.university).child("groups").child(user.group).child("students").child(user.uid)
        newUserRef?.setValue(nil)
        profileView.nameTextField.isEnabled = false
        profileView.nameTextField.layer.borderWidth = 0
        profileView.emailTextField.isEnabled = false
        profileView.emailTextField.layer.borderWidth = 0
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    fileprivate func setupView() {
        profileView.nameTextField.delegate = self
        profileView.emailTextField.delegate = self
        createToolBar()
        hideKeyboard()
        view.addSubview(profileView)
        profileView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    fileprivate func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(dismissKeyboard))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexibleButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.backgroundColor = #colorLiteral(red: 0.8138477206, green: 0.8237602115, blue: 0.8536676764, alpha: 1)
        profileView.emailTextField.inputAccessoryView = toolbar
        profileView.nameTextField.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        profileView.saveButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case profileView.nameTextField:
            profileView.saveButton.isEnabled = textField.text != user.name
        default:
            profileView.saveButton.isEnabled = textField.text != user.email
        }
    }
}
