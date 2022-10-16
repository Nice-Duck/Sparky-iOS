//
//  TagCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "tagCollectionViewCell"
    
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
    
    func setupAddButton(tag: Tag) {
        tagTitleLabel.text = tag.text
        tagTitleLabel.textColor = tag.buttonType == .delete ? .gray700 : .gray400
        tagButtonImageView.image = getButtonImage(buttonType: tag.buttonType)
        tagStackView.backgroundColor = tag.buttonType == .delete ? .sparkyPink : .clear
        
        if tag.buttonType == .add {
            tagStackView.addDashedBorder(frameSize: CGSize(width: 67, height: 20), borderColor: .gray400)
        } else {
            // 기본적으로 subLayer count가 2이고 만약 점선 layer를 추가하면 subLayer count가 3이됨.
            if var sublayers = tagStackView.layer.sublayers {
                if sublayers.count > 2 {
                    sublayers.removeLast()
                }
                tagStackView.layer.sublayers = sublayers
            }
        }
    }
    
    func getButtonImage(buttonType: ButtonType) -> UIImage {
        switch buttonType {
        case .delete:
            return UIImage(named: "vector971")!
        case .add:
            return UIImage(named: "plus")!
        case .none:
            return UIImage()
        }
    }
}
