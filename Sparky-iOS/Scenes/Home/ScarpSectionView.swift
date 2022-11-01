//
//  ScarpSectionView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit

final class ScrapSectionView: UILabel {
    
    private let sectionHeaderView = UIView().then {
        $0.backgroundColor = .none
    }
    
    private let myScrapTitleLabel = UILabel().then {
        $0.text = "내 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(sectionHeaderView)
        sectionHeaderView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.left.equalTo(self)
            $0.bottom.equalTo(self).offset(12)
            $0.right.equalTo(self)
        }
        
        sectionHeaderView.addSubview(myScrapTitleLabel)
        myScrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(sectionHeaderView)
            $0.left.equalTo(sectionHeaderView).offset(20)
            $0.bottom.equalTo(sectionHeaderView).offset(-12)
        }
    }
}
