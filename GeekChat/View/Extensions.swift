//
//  Extensions.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 23.04.2021.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(backgroundColor: UIColor,
                     title: String,
                     font: UIFont?,
                     cornerRadius: CGFloat = 30,
                     shadow: Bool,
                     titleColor: UIColor) {
        
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if shadow {
            self.layer.shadowColor = UIColor(red: 228/255, green: 34/255, blue: 45/255, alpha: 1).cgColor // E4222D
            self.layer.shadowRadius = 9
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
}

extension UIColor {
    static func geekRed() -> UIColor {
        return UIColor(cgColor: CGColor(red: 207/255, green: 31/255, blue: 40/255, alpha: 1))
    }
}

// Animation Core
extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func addConstraintsWithVisualStrings(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
