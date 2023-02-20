//
//  DynamicHeightTextView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2023/02/18.
//

import Foundation
import UIKit

class DynamicHeightTextView: UITextView {
    
    // 위(8), 아래(8) 디폴트 패딩
    let verticalPadding: CGFloat = 16
//    let lineSpacing: CGFloat = CGFloat(5 * (self.numberOfLines - 1))
    
//    var numberOfLines: Int {
//        let text = text ?? ""
//        let font = font ?? UIFont.systemFont(ofSize: 17)
//        let textHeight = text.size(withAttributes: [.font: font]).height
//        let lineHeight = font.lineHeight
//        let numberOfLines = Int(ceil(textHeight / lineHeight))
//
//        return numberOfLines
//    }

//    override var intrinsicContentSize: CGSize {
//        print("intrinsicContentSize height - \(self.frame.height)")
//        print("intrinsicContentSizeCGFloat.greatestFiniteMagnitude - \(CGFloat.greatestFiniteMagnitude)")
//        
//        return sizeThatFits(CGSize(width: self.bounds.width,
//                                   height: CGFloat.greatestFiniteMagnitude))
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        print("layoutSubviews height - \(self.frame.height)")
//        print("layoutSubviews CGFloat.greatestFiniteMagnitude - \(CGFloat.greatestFiniteMagnitude)")
//        self.invalidateIntrinsicContentSize()
//    }
}

