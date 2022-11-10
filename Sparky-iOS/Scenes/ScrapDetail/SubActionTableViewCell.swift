//
//  SubActionTableViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/04.
//

import UIKit

class SubActionTableViewCell: UITableViewCell {
    
    static let identifier = "SubActionTableViewCell"
    
    let actionLabel = UILabel().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
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
    }
}
