//
//  UIView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/10.
//

import UIKit

extension UIView {
    
    var subviewMaxY: CGFloat {
        return subviews.map { $0.frame.maxY }.max() ?? 0
    }
}
