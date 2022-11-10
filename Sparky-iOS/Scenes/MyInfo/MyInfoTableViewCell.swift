//
//  MyInfoTableViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/09.
//

import UIKit

class MyInfoTableViewCell: UITableViewCell {
    
    static let identifier = "MyInfoTableViewCell"
    
    let actionLabel = UILabel().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    let rightChevronImageView = UIImageView().then {
        $0.image = .rightChevron.withRenderingMode(.alwaysOriginal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(12)
            $0.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(rightChevronImageView)
        rightChevronImageView.snp.makeConstraints {
            $0.right.equalTo(contentView).offset(-12)
            $0.centerY.equalTo(contentView)
        }
    }
}
