//
//  OtherScrapSectionView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit

final class OtherScrapSectionView: UIView {
    
    private let labelStackView = UIStackView().then({
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
    })
    
    private let otherScrapTitleLabel = UILabel().then({
        $0.text = "다른 사람 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    private let otherScrapSubTitleLabel = UILabel().then({
        $0.text = "타 이용자가 저장한 콘텐츠를 추천해줍니다"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .gray600
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints {
            $0.left.equalTo(self).offset(20)
            $0.bottom.equalTo(self).offset(-12)
        }
        
        labelStackView.addArrangedSubview(otherScrapTitleLabel)
        labelStackView.addArrangedSubview(otherScrapSubTitleLabel)
    }
}

