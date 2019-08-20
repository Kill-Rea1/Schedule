//
//  CustomSegmentedControl.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 19/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIControl {
    private var labels = [UILabel]() {
        didSet {
            if let firstLabel = labels.first {
                firstLabel.font = UIFont(name: Comfortaa.regular.rawValue, size: 16.5)
            }
        }
    }
    var thumbView = UIView()
    public var items: [String] = [] {
        didSet {
            setupLabels()
        }
    }
    
    public var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    private func setupLabels() {
        labels.forEach( {$0.removeFromSuperview() })
        
        labels.removeAll(keepingCapacity: true)
        
        items.forEach { (item) in
            let label = UILabel()
            label.text = item
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
            addSubview(label)
            labels.append(label)
        }
    }
    
    private func displayNewSelectedIndex() {
        labels.forEach { (label) in
            label.font = UIFont(name: Comfortaa.regular.rawValue, size: 16)
        }
        
        let label = labels[selectedIndex]
        UIView.animate(withDuration: 0.3, animations: {
            self.thumbView.frame = label.frame
            label.font = UIFont(name: Comfortaa.regular.rawValue, size: 16.5)
        }) { (_) in
            self.thumbView.frame = label.frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        var selectFrame = bounds
        let newWidth = bounds.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = bounds.height
        let labelWidth = bounds.width / CGFloat(items.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
                break
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func setupView() {
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 0.5, alpha: 0.1).cgColor
        backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        setupLabels()
        insertSubview(thumbView, at: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
