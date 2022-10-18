//
//  TagCollectionViewFlowLayout.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/15.
//

import UIKit

class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func setup() {
        self.minimumInteritemSpacing = 6
        self.minimumLineSpacing = 8
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
