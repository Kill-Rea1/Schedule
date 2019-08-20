//
//  CustomAlertController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 05/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CustomAlertControllerDelegate: class {
    func didAdd()
    func didCancel()
}

extension CustomAlertController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if myTextView.textColor == .lightGray && myTextView.isFirstResponder {
            myTextView.text = nil
            myTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if myTextView.text.isEmpty || myTextView.text == "" {
            myTextView.textColor = .lightGray
            myTextView.text = placeholderText
        }
    }
}

class CustomAlertController: UIViewController {
    
    // MARK:- Properties
    
    fileprivate let spacing: CGFloat = 10
    public weak var delegate: CustomAlertControllerDelegate?
    public var placeholderText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupViews()
    }
    
    // MARK:- Setup View
    
    func setupViews() {
        myTextView.delegate = self
        
        createToolBar()
        hideKeyboard()
        
        view.addSubview(blurVisualEffect)
        blurVisualEffect.frame = view.frame
        
        view.addSubview(containerView)
        setupContainerView()
    }
    
    // MARK:- UIKit
    
    fileprivate let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let titleLabel: MainLabel = {
        let label = MainLabel()
        label.text = "Добавьте"
        label.numberOfLines = 0
        return label
    }()
    
    public let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 14
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    public let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        button.backgroundColor = .black
        button.layer.cornerRadius = 14
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        return button
    }()
    
    public let myTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 14
        textView.backgroundColor = .white
        textView.font = UIFont(name: Comfortaa.regular.rawValue, size: 18)
        textView.text = "Some text here..."
        textView.textColor = .lightGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    // MARK:- Fileprivate methods
    
    @objc fileprivate func handleCancel() {
        delegate?.didCancel()
        view.endEditing(true)
    }
    
    @objc fileprivate func handleConfirm() {
        delegate?.didAdd()
        view.endEditing(true)
    }
    
    fileprivate func setupContainerView() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        containerView.addSubview(myTextView)
        
        containerView.addConstraints(view.leadingAnchor, view.trailingAnchor, nil, nil, .init(top: 0, left: 16, bottom: 0, right: 16))
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel.addConstraints(containerView.leadingAnchor, containerView.trailingAnchor, containerView.topAnchor, nil, .init(top: 5, left: 0, bottom: 0, right: 0), .init(width: 0, height: 40))
        myTextView.addConstraints(containerView.leadingAnchor, containerView.trailingAnchor, titleLabel.bottomAnchor, cancelButton.topAnchor, .init(top: spacing, left: 20, bottom: spacing * 1.5, right: 20))
        cancelButton.addConstraints(containerView.leadingAnchor, containerView.centerXAnchor, nil, containerView.bottomAnchor, .init(top: 0, left: 20, bottom: 8, right: 8), .init(width: 0, height: 40))
        confirmButton.addConstraints(containerView.centerXAnchor, containerView.trailingAnchor, nil, containerView.bottomAnchor, .init(top: 0, left: 8, bottom: 8, right: 20), .init(width: 0, height: 40))
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
        myTextView.inputAccessoryView = toolbar
    }
    
    fileprivate func hideKeyboard () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        blurVisualEffect.contentView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func handleTap() {
        delegate?.didCancel()
        view.endEditing(true)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}
