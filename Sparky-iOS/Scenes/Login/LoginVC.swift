//
//  ViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/11.
//

import UIKit
import SnapKit
import Then

final class LoginVC: UIViewController {
    
    // MARK: - Properties
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "vector")
    }
    
    private let idTitleLabel = UILabel().then {
        $0.text = "아이디/이메일"
        $0.font = UIFont.bodyRegular2
    }
    
    private let idTextField = UITextField().then {
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
    
    private let passwardTitleLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 400))
    }
    
    private let passwardTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "영문/숫자포함 8~20자",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = UIFont.bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor.black
    }
    
    private let buttonStackView = UIStackView().then({
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    })
    
    private let signUpButton = UIButton().then {
        $0.setTitle("이메일 회원 가입", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .bodyRegular1
        $0.addTarget(self,
                     action: #selector(didTapSignUpButton),
                     for: .touchUpInside)
    }
    
    private let barView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let passwardSearchButton = UIButton().then {
        $0.setTitle("비밀 번호 찾기", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .bodyRegular1
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            $0.centerX.equalTo(view)
        }
        
        view.addSubview(idTitleLabel)
        idTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(32)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(passwardTitleLabel)
        passwardTitleLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(passwardTextField)
        passwardTextField.snp.makeConstraints {
            $0.top.equalTo(passwardTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(40)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwardTextField.snp.bottom).offset(22)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.left.equalTo(view).offset((view.frame.size.width - 156) / 2)
        }
        
        buttonStackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(26)
        }
        
        buttonStackView.addArrangedSubview(barView)
        barView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalToSuperview().offset(-12)
        }
        
        buttonStackView.addArrangedSubview(passwardSearchButton)
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(26)
        }
        
    }
    
    @objc private func didTapSignUpButton() {
        let signUpVC1 = SignUpVC1()
        self.navigationController?.pushViewController(signUpVC1, animated: true)
    }
}

