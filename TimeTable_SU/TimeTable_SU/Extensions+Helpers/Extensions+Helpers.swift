//
//  Extensions.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){}
}

class BaseScrollView: UIScrollView {
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    func setupViews(){}
}

class BaseCell: MGSwipeTableCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {}
}

extension UserDefaults {
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
}

class MainLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .black
        self.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        self.backgroundColor = .clear
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WarningLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.textColor = .red
        self.font = UIFont(name: Comfortaa.regular.rawValue, size: 20)
        self.backgroundColor = .clear
        self.textAlignment = .center
        self.numberOfLines = 0
        self.alpha = 0
        self.text = "Warning"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 14
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        self.translatesAutoresizingMaskIntoConstraints = false
        let paddingViewSubject = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingViewSubject
        self.leftViewMode = UITextField.ViewMode.always
        self.keyboardAppearance = .light
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: UIFont().myFont(), size: 11)!], for: .normal)
//        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.tintColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        self.layer.cornerRadius = 12
        self.selectedSegmentIndex = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    func addConstraints(_ leading: NSLayoutXAxisAnchor?, _ trailing: NSLayoutXAxisAnchor?, _ top: NSLayoutYAxisAnchor?, _ bottom: NSLayoutYAxisAnchor?, _ padding: UIEdgeInsets = .zero, _ size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        addSize(to: size)
    }
    
    func addSize(to size: CGSize = .zero) {
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIFont {
    func myFont() -> String{
        return "Comfortaa"
    }
}
