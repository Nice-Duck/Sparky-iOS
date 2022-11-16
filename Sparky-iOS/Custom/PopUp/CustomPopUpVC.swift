//
//  CustomPopUpVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/09.
//

import UIKit

protocol CustomPopUpDelegate: AnyObject {
    func action()   // confirm button event
    func exit()     // cancel button event
}

class CustomPopUpVC: UIViewController {
    
    weak var customPopUpDelegate: CustomPopUpDelegate?
    
    var containerView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 8
    }
    
    var titleLabel = UILabel().then {
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
        $0.numberOfLines = 2
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 11
    }
    
    var cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitleColor(.sparkyBlack, for: .normal)
        $0.backgroundColor = .sparkyWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.addTarget(self,
                     action: #selector(cancelButtonTapped(_:)),
                     for: .touchUpInside)
    }
    
    var confirmButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.backgroundColor = .sparkyOrange
        $0.addTarget(self,
                     action: #selector(confirmButtonTapped(_:)),
                     for: .touchUpInside)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .sparkyBlack.withAlphaComponent(0.7)
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(335)
            $0.height.equalTo(157)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(40)
            $0.centerX.equalTo(containerView)
        }
        
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.left.equalTo(containerView).offset(12)
            $0.bottom.equalTo(containerView).offset(-12)
            $0.right.equalTo(containerView).offset(-12)
        }
        
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.left.equalTo(containerView).offset(12)
            $0.bottom.equalTo(containerView).offset(-12)
            $0.right.equalTo(containerView).offset(-12)
        }
        
        buttonStackView.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(43)
        }
        
        buttonStackView.addArrangedSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(43)
        }
    }
    
    func setupValue(title: String, cancelText: String, confirmText: String) {
        titleLabel.text = title
        cancelButton.setTitle(cancelText, for: .normal)
        confirmButton.setTitle(confirmText, for: .normal)
    }
    
    @objc func confirmButtonTapped(_ sender: Any) {
        self.dismiss(animated: false) {
            self.customPopUpDelegate?.action()
        }
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: false) {
            self.customPopUpDelegate?.exit()
        }
    }
}
