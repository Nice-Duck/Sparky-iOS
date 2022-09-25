//
//  UITextField+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import Foundation
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
}
