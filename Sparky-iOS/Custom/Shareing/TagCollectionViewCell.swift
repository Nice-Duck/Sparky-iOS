//
//  TagCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "tagCollectionViewCell"
    
    let tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.layer.cornerRadius = 8
        $0.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let tagTitleLabel = UILabel().then {
        $0.font = .badgeBold
    }
    
    let tagAddButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("frame.size - \(frame.size)")
        
        if tagStackView.backgroundColor == .clear {
            tagStackView.addDashedBorder(borderColor: .gray400)
        }
        
        //        tagStackView.systemLayoutSizeFitting(
        //            tagStackView.frame.size,
        //            withHorizontalFittingPriority: .defaultHigh,
        //            verticalFittingPriority: .fittingSizeLevel)
    }
    
    //    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    //        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
    //        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
    //            targetSize,
    //            withHorizontalFittingPriority: .required,
    //            verticalFittingPriority: .fittingSizeLevel)
    //        return layoutAttributes
    //    }
    
    func setupConstraints() {
        contentView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.equalTo(contentView)
            $0.bottom.equalTo(contentView)
            $0.right.equalTo(contentView)
        }
        
        tagStackView.addArrangedSubview(tagTitleLabel)
        tagStackView.addArrangedSubview(tagAddButton)
    }
    
    func setupAddButton(tag: Tag) {
        tagTitleLabel.text = tag.text
        tagTitleLabel.textColor = tag.buttonType == .delete ? .gray700 : .gray400
        tagAddButton.setImage(getButtonImage(buttonType: tag.buttonType),
                              for: .normal)
        tagStackView.backgroundColor = tag.buttonType == .delete ? .sparkyPink : .clear
    }
    
    func getButtonImage(buttonType: ButtonType) -> UIImage {
        switch buttonType {
        case .delete:
            return UIImage(named: "vector971")!
        case .add:
            return UIImage(named: "plus")!
        }
    }
}
