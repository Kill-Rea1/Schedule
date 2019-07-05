//
//  CustomAlertController.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 05/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

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
            myTextView.text = "Some text here..."
        }
    }
}

class CustomAlertController: BaseView {
    
    // MARK:- Properties
    
    fileprivate let spacing: CGFloat = 10
    
    // MARK:- Setup View
    
    override func setupViews() {
        super.setupViews()
        myTextView.delegate = self
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        createToolBar()
        hideKeyboard()
        addSubview(containerView)
        setupContainerView()
    }
    
    // MARK:- UIKit
    
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
        button.titleLabel?.font = UIFont(name: UIFont().myFont(), size: 16)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 14
        button.tintColor = .white
        return button
    }()
    
    public let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont().myFont(), size: 16)
        button.backgroundColor = .black
        button.layer.cornerRadius = 14
        button.tintColor = .white
        return button
    }()
    
    public let myTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 14
        textView.backgroundColor = .white
        textView.font = UIFont(name: UIFont().myFont(), size: 18)
        textView.text = "Some text here..."
        textView.textColor = .lightGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    // MARK:- Fileprivate methods
    
    fileprivate func setupContainerView() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        containerView.addSubview(myTextView)
        
        containerView.widthAnchor.constraint(equalToConstant: 275).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
}
