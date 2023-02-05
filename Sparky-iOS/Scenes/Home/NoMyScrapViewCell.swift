//
//  NoMyScrapViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2023/01/02.
//

import Foundation
import UIKit
import RxSwift

final class NoMyScrapViewCell: UITableViewCell {
    
    static let identifier = "NoMyScrapViewCell"
    
    let disposeBag = DisposeBag()
    let noScrapContainerView = UIView()
    
    let noScrapImageView = UIImageView().then {
        $0.image = .noMyScrap.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .gray600
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowColor = UIColor.sparkyBlack.cgColor
    }
    
    let noScraptitleLabel = UILabel().then {
        $0.text = "최근 저장한 스크랩이 없어요\n 아래 버튼을 눌러 스크랩을 추가해 보세요"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .gray600
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowColor = UIColor.sparkyBlack.cgColor
        $0.numberOfLines = 2
    }
    
    let addButtonContainerView = UIView().then {
        $0.backgroundColor = .sparkyBlack
        $0.layer.cornerRadius = 8
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowColor = UIColor.sparkyBlack.cgColor
    }
    
    let addButtonTextView = UIView()
    
    let addButtonTextLabel = UILabel().then {
        $0.text = "스크랩 추가하기"
        $0.font = .bodyRegular2
        $0.textAlignment = .center
        $0.textColor = .sparkyWhite
    }
    
    let addButtonImageView = UIImageView().then {
        $0.image = .plus.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .sparkyWhite
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        didTapAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .background
        
        contentView.addSubview(noScrapContainerView)
        noScrapContainerView.snp.makeConstraints {
            $0.top.equalTo(self).offset(12)
            $0.left.equalTo(self)
            $0.bottom.equalTo(self).offset(-12)
            $0.right.equalTo(self)
        }
        
        noScrapContainerView.addSubview(noScrapImageView)
        noScrapImageView.snp.makeConstraints {
            $0.top.equalTo(noScrapContainerView)
            $0.centerX.equalTo(noScrapContainerView)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
        
        noScrapContainerView.addSubview(noScraptitleLabel)
        noScraptitleLabel.snp.makeConstraints {
            $0.top.equalTo(noScrapImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(noScrapContainerView)
        }
        
        noScrapContainerView.addSubview(addButtonContainerView)
        addButtonContainerView.snp.makeConstraints {
            $0.top.equalTo(noScraptitleLabel.snp.bottom).offset(12)
            $0.centerX.equalTo(noScrapContainerView)
            $0.width.equalTo(149)
            $0.height.equalTo(40)
        }
        
        addButtonContainerView.addSubview(addButtonTextView)
        addButtonTextView.snp.makeConstraints {
            $0.top.equalTo(addButtonContainerView).offset(12)
            $0.left.equalTo(addButtonContainerView).offset(20)
            $0.bottom.equalTo(addButtonContainerView).offset(-12)
            $0.right.equalTo(addButtonContainerView).offset(-20)
        }
        
        addButtonTextView.addSubview(addButtonTextLabel)
        addButtonTextLabel.snp.makeConstraints {
            $0.left.equalTo(addButtonTextView)
            $0.centerY.equalTo(addButtonTextView)
        }
        addButtonTextView.addSubview(addButtonImageView)
        addButtonImageView.snp.makeConstraints {
            $0.right.equalTo(addButtonTextView)
            $0.centerY.equalTo(addButtonTextView)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
    }
    
    private func didTapAddButton() {
        addButtonContainerView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe { _ in
                print("추가하기 버튼 클릭!")
                NotificationCenter.default.post(
                    name: SparkyNotification.showScrapShareVC,
                    object: nil,
                    userInfo: nil)
            }.disposed(by: disposeBag)
    }
}
