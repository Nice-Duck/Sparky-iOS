//
//  TagCollectionView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/15.
//

import UIKit

class TagCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
