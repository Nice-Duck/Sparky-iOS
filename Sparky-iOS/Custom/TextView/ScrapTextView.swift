//
//  ScrapTextView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2023/02/21.
//

import Foundation
import UIKit

final class ScrapTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextView() {
        textAlignment = .left
        textColor = .black
        textContainer.maximumNumberOfLines = 2
        textContainer.lineBreakMode = .byTruncatingTail
        isEditable = false
        isScrollEnabled = false
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
}
