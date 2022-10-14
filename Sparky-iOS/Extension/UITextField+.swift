//
//  UITextField+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit

extension UITextField {
    
    func setLeftPadding(_ offset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: offset,
                                               height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ offset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: offset,
                                               height: self.frame.size.height))
        self.rightView = paddingView
        self.leftViewMode = .always
    }
    
    func attributedPlaceholder(text: String, color: UIColor?, font: UIFont?) {
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
}
