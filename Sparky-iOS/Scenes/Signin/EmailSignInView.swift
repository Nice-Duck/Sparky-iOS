//
//  SignInView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import UIKit

class EmailSignInView: UIView {
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "vector")
    }
    
    let emailTitleLabel = UILabel().then {
        $0.text = "아이디/이메일"
        $0.font = UIFont.bodyRegular2
    }
    
    let emailTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "example@sparky.com",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
    }
    
    let passwordTitleLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 400))
    }
    
    let passwordTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "영문/숫자포함 8~20자",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
        $0.isSecureTextEntry = true
    }
    
    let signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = UIFont.bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor.black
    }
    
    let buttonStackView = UIStackView().then({
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    })
    
    let signUpButton = UIButton().then {
        $0.setTitle("이메일 회원 가입", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .bodyRegular1
//        $0.addTarget(self,
//                     action: #selector(didTapSignUpButton),
//                     for: .touchUpInside)
    }
    
    let barView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    let passwordSearchButton = UIButton().then {
        $0.setTitle("비밀 번호 찾기", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .bodyRegular1
    }
    
    func showError(message: String) {
        
    }
}
