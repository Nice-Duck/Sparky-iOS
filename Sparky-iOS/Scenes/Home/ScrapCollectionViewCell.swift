//
//  ScrapCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/28.
//

import UIKit


final class ScrapCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "myScrapCollectionViewCell"
    
    let topContainerView = UIView()
    let tagCollectionView = TagCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                              collectionViewLayout: TagCollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit"), for: .normal)
    }
    
    let thumbnailButton = UIImageView().then {
        $0.image = UIImage(named: "vector")
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 4
    }
    
    let titleLabel = UILabel().then {
        $0.font = .bodyBold2
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    let subTitleLabel = UILabel().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .gray600
    }
    
    func setupConstraints() {
        contentView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(24)
        }
        
        topContainerView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalTo(topContainerView)
            $0.bottom.equalTo(topContainerView)
            $0.right.equalTo(topContainerView)
            $0.width.equalTo(24)
        }
        
        topContainerView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(topContainerView)
            $0.left.equalTo(topContainerView)
            $0.bottom.equalTo(topContainerView)
            $0.right.equalTo(editButton.snp.left).offset(-16)
        }
        
        contentView.addSubview(thumbnailButton)
        thumbnailButton.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(78)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailButton.snp.bottom).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(34)
        }
    }
    
    func setupValue(scrap: Scrap) {
        titleLabel.text = scrap.title
        subTitleLabel.text = scrap.subTitle
        thumbnailButton.setupImageView(frameSize: CGSize(width: contentView.frame.size.width - 24, height: 78), url: URL(string: scrap.thumbnailURLString))
    }
}
