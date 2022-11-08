//
//  SignInVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/11.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SignInVC: UIViewController {
    
    // MARK: - Properties
    let emailSignInView = EmailSignInView()
    let viewModel = EmailSignInViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        bindViewModel()
    }
    
    private func setupConstraints() {
        view.addSubview(emailSignInView.logoImageView)
        emailSignInView.logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            $0.centerX.equalTo(view)
        }
        
        view.addSubview(emailSignInView.emailTitleLabel)
        emailSignInView.emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.logoImageView.snp.bottom).offset(32)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(emailSignInView.emailTextField)
        emailSignInView.emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.emailTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(emailSignInView.passwordTitleLabel)
        emailSignInView.passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.emailTextField.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(emailSignInView.passwordTextField)
        emailSignInView.passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.passwordTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(40)
        }
        
        view.addSubview(emailSignInView.signInButton)
        emailSignInView.signInButton.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.passwordTextField.snp.bottom).offset(22)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(emailSignInView.buttonStackView)
        emailSignInView.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(emailSignInView.signInButton.snp.bottom).offset(20)
            $0.left.equalTo(view).offset((view.frame.size.width - 156) / 2)
        }
        
        emailSignInView.buttonStackView.addArrangedSubview(emailSignInView.signUpButton)
        emailSignInView.signUpButton.snp.makeConstraints {
            $0.height.equalTo(26)
        }
        
        emailSignInView.buttonStackView.addArrangedSubview(emailSignInView.barView)
        emailSignInView.barView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalToSuperview().offset(-12)
        }
        
        emailSignInView.buttonStackView.addArrangedSubview(emailSignInView.passwordSearchButton)
        emailSignInView.signUpButton.snp.makeConstraints {
            $0.height.equalTo(26)
        }
    }
    
    private func bindViewModel() {
        emailSignInView.emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        emailSignInView.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        emailSignInView.emailTextField.rx.text
            .bind(onNext: { value in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                
                if self.emailSignInView.emailTextField.text != "" {
                    if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.emailSignInView.emailTextField.text) {
                        print("타당한 아이디입니다.")
                    } else { print("Invalid Email!") }
                }
            }).disposed(by: disposeBag)
        
        emailSignInView.passwordTextField.rx.text
            .bind(onNext: { value in
                let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
                
                if self.emailSignInView.passwordTextField.text != "" {
                    if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self.emailSignInView.passwordTextField.text) {
                        print("타당한 비밀번호입니다.")
                    } else { print("Invalid Password!") }
                }
            }).disposed(by: disposeBag)
        
        viewModel.isValidSignInButton()
            .map{ $0 ? true : false }
            .bind(to: emailSignInView.signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailSignInView.signInButton.rx.tap.asDriver()
            .throttle(.seconds(3), latest: false)
            .drive { _ in
                let emailSignInRequest = EmailSignInRequest(email: self.emailSignInView.emailTextField.text ?? "",
                                                            pwd: self.emailSignInView.passwordTextField.text ?? "")
                
                print("입력 이메일: \(self.emailSignInView.emailTextField.text ?? "")")
                print("입력 비밀번호: \(self.emailSignInView.passwordTextField.text ?? "")")
                
                UserServiceProvider.shared
                    .signIn(emailSignInRequestModel: emailSignInRequest)
                    .map(EmailSignUpResponse.self)
                    .subscribe { response in
                        if response.code == "0000" {
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                            print("🔑 accessToken - \(response.result?.accessToken ?? "")")
                            print("🔑 refreshToken - \(response.result?.refreshToken ?? "")")
                            
                            if let accessToken = response.result?.accessToken, let refreshToken = response.result?.refreshToken {
                                
                                // 토큰 key chain에 저장
                                let tokenUtils = TokenUtils()
                                tokenUtils.create("com.sparky.token", account: "accessToken", value: accessToken)
                                tokenUtils.create("com.sparky.token", account: "refreshToken", value: refreshToken)
                                
                                // key chain에서 토큰 읽어오기
                                if let accessToken = tokenUtils.read("com.sparky.token", account: "accessToken") {
                                    print("키 체인 액세스 토큰 - \(accessToken)")
                                } else { print("토큰이 존재하지 않습니다!") }
                                if let refreshToken = tokenUtils.read("com.sparky.token", account: "refreshToken") {
                                    print("키 체인 리프레시 토큰 - \(refreshToken)")
                                } else { print("토큰이 존재하지 않습니다!") }
                                
                                print("로그인 성공!")
                                self.moveToHomeVC()
                            }
                        } else {
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: self.disposeBag)
                
                
                //                { response in
                //                    print("response - \(response)")
                ////                    switch response {
                ////                    case .success():
                //                        let homeVC = HomeVC()
                //                        self.navigationController?.pushViewController(homeVC, animated: true)
                ////                    case .failure():
                ////                        print("error - \(error)")
                ////                    }
                //                }
                //
                //            } else { print("Invalid Email or Password!") }
            }.disposed(by: disposeBag)
        
        emailSignInView.signUpButton.rx.tap.subscribe { _ in
            let signUpVC1 = SignUpVC1()
            self.navigationController?.pushViewController(signUpVC1, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func moveToHomeVC() {
        guard let nc = self.navigationController else { return }
        var vcs = nc.viewControllers
        vcs = [HomeVC()]
        self.navigationController?.viewControllers = vcs
    }
}

