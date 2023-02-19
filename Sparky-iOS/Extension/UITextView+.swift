//
//  UITextView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2023/02/17.
//

import Foundation
import UIKit

extension UITextView {
    
    var numberOfLines: Int {
        let text = text ?? ""
        let font = font ?? UIFont.systemFont(ofSize: 17)
        let textHeight = text.size(withAttributes: [.font: font]).height
        let lineHeight = font.lineHeight
        let numberOfLines = Int(ceil(textHeight / lineHeight))
        
        return numberOfLines
    }
    
    func centerVerticalText() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        self.contentInset.top = topCorrect
    }

}
