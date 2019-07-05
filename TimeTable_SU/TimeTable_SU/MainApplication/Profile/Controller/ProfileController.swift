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
    
    let cellId = "cellId"
    
    fileprivate let profileView = ProfileView()
    public var user: UserDB! {
        willSet {
            profileView.nameTextField.text = newValue.name
            self.university = newValue.university
            self.prevUniversity = newValue.university
            self.group = newValue.group
            if !newValue.isAdmin {
                profileView.nameTextFieldLeadingConstraint.constant -= profileView.adminImageView.frame.width
            }
            profileView.adminImageView.isHidden = !newValue.isAdmin
            profileView.emaiTextField.text = newValue.email
        }
    }
    fileprivate var prevUniversity: String!
    fileprivate var prevGroup: String!
    public var university: String! {
        willSet {
            profileView.universityLabel.text = newValue
            if self.university != newValue {
                profileView.groupLabel.text = "Выберете группу"
            }
        }
    }
    public var group: String! {
        willSet {
            profileView.groupLabel.text = "Группа \(newValue ?? "")"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        setupNavigationItem()
        addTargets()
    }
    
    fileprivate func addTargets() {
        profileView.nameChangeButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
        profileView.universityChangeButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
        profileView.groupChangeButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
        profileView.emailChangeButton.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc fileprivate func handleButtonTapped(sender: UIButton) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        switch sender {
        case profileView.nameChangeButton:
            profileView.nameTextField.isEnabled = true
            profileView.nameTextField.layer.borderWidth = 1
        case profileView.emailChangeButton:
            profileView.emaiTextField.isEnabled = true
            profileView.emaiTextField.layer.borderWidth = 1
        default:
            handleSearch(sender: sender)
        }
    }
    
    fileprivate func handleSearch(sender: UIButton) {
        let searchController = SearchController()
        searchController.prevVC = self
        switch sender {
        case profileView.universityChangeButton:
            searchController.isGroupSearching = false
            searchController.isUniversitySearching = true
        default:
            searchController.isGroupSearching = true
            searchController.isUniversitySearching = false
            searchController.selectedUniversity = university
        }
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    fileprivate func setupNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Профиль"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "editProfile"), style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc fileprivate func handleSave() {
        guard let name = profileView.nameTextField.text, name != "" else {
            return
        }
        guard let email = profileView.emaiTextField.text, email != "" else {
            return
        }
        guard let university = university else {
            return
        }
        guard let group = group, group != "Выберете группу" else {
            return
        }
        
        let newUser = UserDB(uid: user.uid, email: email, name: name, university: university, group: group, isAdmin: false)
        var newUserRef = user.ref
        newUserRef?.setValue(newUser.convertToDictionary())
        newUserRef = Database.database().reference().child("universities").child(university).child("groups").child(group).child("students").child(newUser.uid)
        newUserRef?.updateChildValues(["name": newUser.name, "uid": newUser.uid, "email": newUser.email, "isAdmin": false])
        newUserRef? = Database.database().reference().child("universities").child(user.university).child("groups").child(user.group).child("students").child(user.uid)
        newUserRef?.setValue(nil)
        profileView.nameTextField.isEnabled = false
        profileView.nameTextField.layer.borderWidth = 0
        profileView.emaiTextField.isEnabled = false
        profileView.emaiTextField.layer.borderWidth = 0
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc fileprivate func handleMenu() {
        ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? MainController)?.openMenu()
    }
    
    fileprivate func setupView() {
        view.addSubview(profileView)
        profileView.addConstraints(view.safeAreaLayoutGuide.leadingAnchor, view.safeAreaLayoutGuide.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
    }
}
