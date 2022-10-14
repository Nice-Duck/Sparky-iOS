//
//  TagCollectionViewFlowLayout.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/15.
//

import UIKit

class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
        
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftmargin = self.sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach({ layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftmargin = self.sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftmargin
            leftmargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        })
        return attributes
    }
}
