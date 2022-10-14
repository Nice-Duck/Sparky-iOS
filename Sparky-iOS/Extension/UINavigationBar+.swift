//
//  UINavigationController+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/27.
//

import UIKit

extension UINavigationBar {
    
    func titleTextAttributes(color: UIColor, font: UIFont) {
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                           NSAttributedString.Key.font: font]
        
        self.titleTextAttributes = attributes
    }
}
