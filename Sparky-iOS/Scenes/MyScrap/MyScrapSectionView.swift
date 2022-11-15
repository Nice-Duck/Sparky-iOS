//
//  MyScrapSectionView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit

final class MyScrapSectionView: UIView {
    
    static let identifier = "MyScrapSectionView"
    
    let containerView = UIView().then {
        $0.backgroundColor = .background
    }
    
    let totalCountLabel = UILabel().then {
        $0.font = .bodyBold1
        $0.textAlignment = .center
        $0.textColor = .gray700
    }
    
    let rightButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    var setHorizontalViewButton = UIButton().then {
        $0.setImage(.viewAgenda.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .gray400
    }
    
    var setLargeImageViewButton = UIButton().then {
        $0.setImage(.formatListBulleted.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .sparkyBlack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.left.equalTo(self)
            $0.bottom.equalTo(self)
            $0.right.equalTo(self)
        }
        
        containerView.addSubview(totalCountLabel)
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(containerView)
            $0.left.equalTo(containerView)
            $0.bottom.equalTo(containerView)
        }
        
        containerView.addSubview(rightButtonStackView)
        rightButtonStackView.snp.makeConstraints {
            $0.top.equalTo(containerView)
            $0.bottom.equalTo(containerView)
            $0.right.equalTo(containerView)
        }
        
        rightButtonStackView.addArrangedSubview(setHorizontalViewButton)
        rightButtonStackView.addArrangedSubview(setLargeImageViewButton)
    }
}
