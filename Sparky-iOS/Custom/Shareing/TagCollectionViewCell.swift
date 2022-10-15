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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("frame.size - \(frame.size)")
        
        if tagTitleLabel.text == "태그추가" {
            tagStackView.addDashedBorder(borderColor: .gray400)
        }
    }

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
