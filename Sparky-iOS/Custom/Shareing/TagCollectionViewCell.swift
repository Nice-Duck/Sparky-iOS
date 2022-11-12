//
//  TagCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TagCollectionViewCell"
    
    var tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.layer.cornerRadius = 8
        $0.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let tagTitleLabel = UILabel().then {
        $0.font = .badgeBold
    }
    
    let tagButtonImageView = UIImageView()
    
    func setupConstraints() {
        contentView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.equalTo(contentView)
            $0.bottom.equalTo(contentView)
            $0.right.equalTo(contentView)
        }
        
        tagStackView.addArrangedSubview(tagTitleLabel)
        tagStackView.addArrangedSubview(tagButtonImageView)
    }
    
    func setupTagButton(tag: Tag) {
        tagTitleLabel.text = tag.name
        tagTitleLabel.textColor = tag.buttonType != .add ? .sparkyBlack : .gray400
        tagButtonImageView.image = getButtonImage(buttonType: tag.buttonType)
        tagButtonImageView.isHidden = tag.buttonType == .none ? true : false
        tagStackView.backgroundColor = tag.buttonType != .add ? tag.color : .clear
    }
    
    func getButtonImage(buttonType: ButtonType) -> UIImage? {
        switch buttonType {
        case .delete:
            return UIImage(named: "vector971")!
        case .add:
            return UIImage(named: "plus")!
        case .none:
            return nil
        }
    }
}
