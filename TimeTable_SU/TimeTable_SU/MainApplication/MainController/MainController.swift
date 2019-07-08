//
//  ContainerViewController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class CurrentView: UIView {}
class SideView: UIView {}
class DarkCoverView: UIView {}

class MainController: UIViewController, UINavigationControllerDelegate {
    
    // MARK:- Properties
    
    fileprivate var mainViewLeadingConstraint: NSLayoutConstraint!
    fileprivate var mainViewTrailingConstraint: NSLayoutConstraint!
    fileprivate let menuWidth: CGFloat = 300
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var isMenuOpened = false
    fileprivate var currentController: UIViewController = UINavigationController(rootViewController: TimetableController())
    public var isAddControllerOpened = true {
        willSet {
            panGesture.isEnabled = !newValue
        }
    }
    
    // MARK:- Views
    
    fileprivate let currentView: CurrentView = {
        let v = CurrentView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate let sideView: SideView = {
        let v = SideView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate let darkCoverView: DarkCoverView = {
        let v = DarkCoverView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK:- ViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.navigationBar.isHidden = true
        setupGestures()
    }
    
    // MARK:- Public Methods
    
    public func navigate(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func openMenu() {
        isMenuOpened = true
        mainViewLeadingConstraint.constant = menuWidth
        mainViewTrailingConstraint.constant = menuWidth
        performAnimations()
    }
    
    public func closeMenu() {
        isMenuOpened = false
        mainViewLeadingConstraint.constant = 0
        mainViewTrailingConstraint.constant = 0
        performAnimations()
    }
    
    public func didSelectMenuItem(indexPathRow: Int) {
        performCleanUp()
        closeMenu()
        switch indexPathRow {
        case 0:
            currentController = UINavigationController(rootViewController: TimetableController())
        case 1:
            currentController = UINavigationController(rootViewController: SessionController())
        case 2:
            currentController = UINavigationController(rootViewController: ProfileController())
        case 3:
            currentController = UINavigationController(rootViewController: GroupController())
        default:
            do {
                try Auth.auth().signOut()
                
            } catch {
                print(error.localizedDescription)
            }
            UserDefaults.standard.setIsLoggedIn(value: false)
            let enterController = EnterController()
            navigationController?.viewControllers = [enterController]
            dismiss(animated: true, completion: nil)
        }
        currentView.addSubview(currentController.view)
        addChild(currentController)
        currentView.bringSubviewToFront(darkCoverView)
    }
    
    // MARK:- Fileprivate Methods
    
    fileprivate func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleTapDismiss() {
        closeMenu()
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        x = isMenuOpened ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x)
        
        mainViewLeadingConstraint.constant = x
        mainViewTrailingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
        
        if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if isMenuOpened {
            if velocity.x < -velocityThreshold {
                closeMenu()
                return
            }
            if translation.x > -menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if velocity.x > velocityThreshold {
                openMenu()
                return
            }
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
    fileprivate func performCleanUp() {
        currentController.view.removeFromSuperview()
        currentController.removeFromParent()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
        })
    }
    
    fileprivate func setupViews() {
        view.addSubview(currentView)
        view.addSubview(sideView)
        
        currentView.addConstraints(nil, nil, view.topAnchor, view.bottomAnchor)
        sideView.addConstraints(nil, currentView.leadingAnchor, view.topAnchor, currentView.bottomAnchor, .init(), .init(width: menuWidth, height: 0))
        
        mainViewLeadingConstraint = currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        mainViewLeadingConstraint.isActive = true
        
        mainViewTrailingConstraint = currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        mainViewTrailingConstraint.isActive = true
        
        setupControllers()
    }
    
    fileprivate func setupControllers() {
        let menuController = UINavigationController(rootViewController: MenuController())
        let timetableView = currentController.view!
        let menuView = menuController.view!
        
        timetableView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        currentView.addSubview(timetableView)
        currentView.addSubview(darkCoverView)
        sideView.addSubview(menuView)
        
        timetableView.addConstraints(currentView.leadingAnchor, currentView.trailingAnchor, currentView.topAnchor, currentView.bottomAnchor)
        menuView.addConstraints(sideView.leadingAnchor, sideView.trailingAnchor, sideView.topAnchor, sideView.bottomAnchor)
        darkCoverView.addConstraints(currentView.leadingAnchor, currentView.trailingAnchor, currentView.topAnchor, currentView.bottomAnchor)
        
        addChild(currentController)
        addChild(menuController)
    }
}
