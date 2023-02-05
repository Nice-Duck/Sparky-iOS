//
//  TagCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/12.
//

import UIKit

enum ActionType {
    case search, display
}

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setupTagButton(tag: Tag, actionType: ActionType) {
        tagStackView.removeDashedBorder()
        tagTitleLabel.text = tag.name
        tagStackView.backgroundColor = tag.color
        
        switch tag.buttonType {
        case .add:
            switch actionType {
            case .display:
                tagTitleLabel.textColor = .gray400
                tagButtonImageView.image = getButtonImage(buttonType: tag.buttonType)
                tagButtonImageView.tintColor = .gray400
                tagStackView.addDashedBorder(frameSize: CGSize(width: 67, height: 20), borderColor: .gray400)
            case .search:
                tagTitleLabel.textColor = .sparkyWhite
                tagButtonImageView.image = getButtonImage(buttonType: tag.buttonType)
                tagButtonImageView.tintColor = .sparkyWhite
            }
        case .delete, .none:
            tagTitleLabel.text = tag.name
            tagTitleLabel.textColor = .sparkyBlack
            switch tag.buttonType {
            case .delete:
                tagButtonImageView.image = getButtonImage(buttonType: tag.buttonType)
                tagButtonImageView.tintColor = tag.buttonType != .add ? .sparkyBlack : .sparkyWhite
            default:
                tagButtonImageView.isHidden = true
            }            
        }
    }
    
    func getButtonImage(buttonType: ButtonType) -> UIImage? {
        switch buttonType {
        case .delete:
            return .delete.withRenderingMode(.alwaysTemplate)
        case .add:
            return .plus.withRenderingMode(.alwaysTemplate)
        case .none:
            return nil
        }
    }
}
