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
        $0.font = UIFont.heading2
    }
    
    private let idTextField = UITextField().then {
        $0.attributedPlaceholder(text: "example@sparky.com",
                                 color: .gray1,
                                 font: .heading2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray1.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
    }
    
    private let passwardTitleLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 400))
    }
    
    private let passwardTextField = UITextField().then {
        $0.attributedPlaceholder(text: "영문/숫자포함 8~20자",
                                 color: .gray1,
                                 font: .heading2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray1.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.heading1
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor.black
        $0.addTarget(self,
                     action: #selector(didTapLoginButton),
                     for: .touchUpInside)
    }
    
    private let buttonsView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let accountSearchButtonStackView = UIStackView().then({
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
    })
    
    private let idSearchButton = UIButton().then {
        $0.setTitle("아이디 찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .heading2
    }
    
    private let barView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        $0.backgroundColor = .gray1
    }
    
    private let passwardSearchButton = UIButton().then {
        $0.setTitle("비밀 번호 찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .heading2
    }
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원 가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .heading2
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(47)
            $0.centerX.equalTo(view)
        }
        
        view.addSubview(idTitleLabel)
        idTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(38)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(21)
        }
        
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idTitleLabel.snp.bottom).offset(7)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(50)
        }
        
        view.addSubview(passwardTitleLabel)
        passwardTitleLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(21)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(21)
        }
        
        view.addSubview(passwardTextField)
        passwardTextField.snp.makeConstraints {
            $0.top.equalTo(passwardTitleLabel.snp.bottom).offset(7)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(40)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwardTextField.snp.bottom).offset(22)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(50)
        }
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(7)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(30)
        }
        
        buttonsView.addSubview(accountSearchButtonStackView)
        accountSearchButtonStackView.snp.makeConstraints {
            $0.top.equalTo(buttonsView.snp.top)
            $0.left.equalTo(buttonsView.snp.left)
            $0.bottom.equalTo(buttonsView.snp.bottom)
        }
        accountSearchButtonStackView.addArrangedSubview(idSearchButton)
        accountSearchButtonStackView.addArrangedSubview(barView)
        barView.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.height.equalToSuperview().offset(-20)
        }
        
        accountSearchButtonStackView.addArrangedSubview(passwardSearchButton)
        
        buttonsView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(buttonsView.snp.top)
            $0.bottom.equalTo(buttonsView.snp.bottom)
            $0.right.equalTo(buttonsView.snp.right)
        }
        
    }
    
    @objc private func didTapLoginButton() {
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .overFullScreen
        self.present(homeVC, animated: true)
    }
}

