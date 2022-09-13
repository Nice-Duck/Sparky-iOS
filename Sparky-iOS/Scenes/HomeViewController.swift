//
//  ViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/11.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private let titleLabel = UILabel().then {
        $0.text = "Sparky"
        $0.font = .boldSystemFont(ofSize: 22)
        $0.textAlignment = .center
    }
    
    private let idTextField = UITextField().then {
        $0.placeholder = "로그인"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemTeal.cgColor
        $0.layer.cornerRadius = 15
        $0.setLeftPadding(16)
    }
    
    private let passwardTextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemTeal.cgColor
        $0.layer.cornerRadius = 15
        $0.setLeftPadding(16)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.orange.cgColor
        $0.layer.cornerRadius = 15
    }
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view).offset(100)
            $0.centerX.equalTo(view)
        }
        
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(40)
        }
        
        view.addSubview(passwardTextField)
        passwardTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(40)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwardTextField.snp.bottom).offset(32)
            $0.left.equalTo(view).offset(32)
            $0.right.equalTo(view).offset(-32)
            $0.height.equalTo(40)
        }
    }
}

