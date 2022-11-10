//
//  TagCollectionView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/15.
//

import UIKit

class TagCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    private func setupUI() {
        self.register(TagCollectionViewCell.self,
                      forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
