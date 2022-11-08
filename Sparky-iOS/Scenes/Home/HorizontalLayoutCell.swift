//
//  HorizontalLayoutCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/07.
//

import UIKit
import RxSwift


final class HorizontalLayoutCell: UICollectionViewCell {
    
    static let identifier = "HorizontalLayoutCell"
    
    let disposeBag = DisposeBag()
    
    let topContainerView = UIView()
    let tagCollectionView = TagCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                              collectionViewLayout: TagCollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let scrapDetailButton = UIButton().then {
        $0.setImage(UIImage(named: "edit"), for: .normal)
    }
    
    var bottomContainerView = UIView()
    let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "vector")
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 4
    }
    
    let titleLabel = CustomVAlignLabel().then {
        $0.font = .bodyBold2
        $0.textAlignment = .left
        $0.textColor = .sparkyBlack
        $0.numberOfLines = 2
        $0.verticalAlignment = .top
    }
    
    let subTitleLabel = CustomVAlignLabel().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .left
        $0.textColor = .gray600
        $0.numberOfLines = 2
        $0.verticalAlignment = .top
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setDidTapScrapDetailButton()
        setDidTapScrapthumbnailImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        contentView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(24)
        }
        
        topContainerView.addSubview(scrapDetailButton)
        scrapDetailButton.snp.makeConstraints {
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
            $0.right.equalTo(scrapDetailButton.snp.left).offset(-16)
        }
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(82)
        }
        
        bottomContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(bottomContainerView)
            $0.left.equalTo(bottomContainerView)
            $0.width.equalTo(100)
            $0.height.equalTo(70)
        }
        
        bottomContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomContainerView)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.right.equalTo(bottomContainerView)
        }
        
        bottomContainerView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.right.equalTo(bottomContainerView)
        }
    }
    
    func setupLargeImageConstraints() {
        contentView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(24)
        }
        
        topContainerView.addSubview(scrapDetailButton)
        scrapDetailButton.snp.makeConstraints {
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
            $0.right.equalTo(scrapDetailButton.snp.left).offset(-16)
        }
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(140)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
        }
    }
    
    func setupValue(scrap: Scrap) {
        titleLabel.text = scrap.title
        subTitleLabel.text = scrap.subTitle
        thumbnailImageView.setupImageView(frameSize: CGSize(width: contentView.frame.size.width - 24, height: 78), url: URL(string: scrap.thumbnailURLString))
    }
    
    func setDidTapScrapDetailButton() {
        scrapDetailButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe { _ in
                NotificationCenter.default.post(name: SparkyNotification.sendScrapDetailIndex, object: self.scrapDetailButton.tag)
            }.disposed(by: disposeBag)
    }
    
    func setDidTapScrapthumbnailImageView() {
        thumbnailImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                let selectedIndex = self.thumbnailImageView.tag
                NotificationCenter.default.post(name: SparkyNotification.sendScrapWebViewIndex, object: selectedIndex)
            }.disposed(by: disposeBag)
    }
}

