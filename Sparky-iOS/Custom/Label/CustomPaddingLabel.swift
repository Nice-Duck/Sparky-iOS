//
//  CustomPaddingLabel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/23.
//

import UIKit

class CustomPaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
