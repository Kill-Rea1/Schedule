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
    
    fileprivate let profileView = ProfileView()
    fileprivate var ref: DatabaseReference!
    fileprivate var user: UserDB! {
        willSet {
            profileView.nameTextField.text = newValue.name
            self.university = newValue.university
            self.group = newValue.group
            self.isAdmin = newValue.isAdmin
        }
    }
    public var university: String! {
        willSet {
            profileView.universityLabel.text = newValue
            if university != nil && newValue != university {
                profileView.saveButton.isEnabled = true
                profileView.groupChangeButton.setTitle("Выберете группу", for: .normal)
            }
        }
    }
    public var group: String! {
        willSet {
            profileView.groupLabel.text = "Группа \(newValue ?? "")"
            if group != nil && newValue != group {
                profileView.saveButton.isEnabled = true
            }
        }
    }
    public var isAdmin: Bool! {
        willSet {
            profileView.adminImageView.isHidden = !newValue
        }
    }
    
    // MARK:- View Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupNavigationItem()
        addTargets()
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
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        profileView.contentSize = CGSize(width: profileView.contentSize.width, height: profileView.contentSize.height + keyboardFrameSize.height)
        profileView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        profileView.contentSize = CGSize(width: profileView.contentSize.width, height: profileView.contentSize.height - keyboardFrameSize.height)
        profileView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func addTargets() {
        profileView.nameChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.universityChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.groupChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.passwordChangeButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    @objc fileprivate func handleButtonTapped(sender: UIButton) {
        switch sender {
        case profileView.nameChangeButton:
            profileView.nameTextField.isEnabled = true
            profileView.nameTextField.layer.borderWidth = 1
            profileView.nameTextField.becomeFirstResponder()
        case profileView.passwordChangeButton:
            let navController = UINavigationController(rootViewController: ChangePasswordController())
            present(navController, animated: true, completion: nil)
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
        let navController = UINavigationController(rootViewController: searchController)
        present(navController, animated: true)
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
        guard let university = university else {
            return
        }
        guard let group = group, group != "Выберете группу" else {
            return
        }
        
        guard let isAdmin = isAdmin else {
            return
        }
        
        let newUser = UserDB(uid: user.uid, email: user.email, name: name, university: university, group: group, isAdmin: isAdmin)
        var newUserRef = user.ref
        newUserRef?.setValue(newUser.convertToDictionary())
        newUserRef? = Database.database().reference().child("universities").child(user.university).child("groups").child(user.group).child("students").child(user.uid)
        newUserRef?.setValue(nil)
        newUserRef = Database.database().reference().child("universities").child(university).child("groups").child(group).child("students").child(newUser.uid)
        newUserRef?.updateChildValues(["name": newUser.name, "uid": newUser.uid, "email": newUser.email, "isAdmin": isAdmin])
        profileView.nameTextField.isEnabled = false
        profileView.nameTextField.layer.borderWidth = 0
        profileView.saveButton.isEnabled = false
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    fileprivate func setupView() {
        profileView.nameTextField.delegate = self
        view.addSubview(profileView)
        profileView.addConstraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.bottomAnchor)
    }
    
    fileprivate func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users").child(uid)
        ref.observe(.value) { [weak self] (snapshot) in
            let user = UserDB(snapshot: snapshot)
            self?.user = user
        }
    }
}

extension ProfileController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case profileView.nameTextField:
            profileView.saveButton.isEnabled = textField.text != user.name
        default:
            profileView.saveButton.isEnabled = textField.text != user.email
        }
    }
}
