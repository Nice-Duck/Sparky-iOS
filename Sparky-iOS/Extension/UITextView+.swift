//
//  UITextView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2023/02/17.
//

import Foundation
import UIKit

extension UITextView {
    
    func sizeToTextLength() {
        print("frame width - \(frame.width)")
        
        let frameWidth = frame.width
        let text = text ?? ""
        let font = font ?? UIFont.systemFont(ofSize: 17)
        let textSize = text.size(withAttributes: [.font: font])
        
        
        print("textSize - \(textSize)")
        
        if textSize.width / frameWidth > 1 {
            heightAnchor.constraint(equalToConstant: textSize.height * 2).isActive = true
        } else {
            heightAnchor.constraint(equalToConstant: textSize.height).isActive = true
        }
    }
}
