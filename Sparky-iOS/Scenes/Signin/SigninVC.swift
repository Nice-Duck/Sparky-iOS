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
        
        emailSignInView.signInButton.rx.tap.subscribe { [self] _ in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
            
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.emailSignInView.emailTextField.text) && NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self.emailSignInView.passwordTextField.text) {
                
                let emailSignInRequest = EmailSignInRequest(email: emailSignInView.emailTextField.text ?? "",
                                                            password: emailSignInView.passwordTextField.text ?? "")
                
                print("입력 이메일: \(self.emailSignInView.emailTextField.text ?? "")")
                print("입력 비밀번호: \(self.emailSignInView.passwordTextField.text ?? "")")
                
                UserServiceProvider.shared
                    .signIn(emailSignInRequestModel: emailSignInRequest)
                    .map(EmailSignInResponse.self)
                    .subscribe { response in
                        print("🔑 accessToken - \(response.result?.accessToken ?? "")")
                        print("🔑 refreshToken - \(response.result?.refreshToken ?? "")")
                        
                        if let result = response.result {
                            let homeVC = HomeVC()
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: disposeBag)
            }

                
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
        }
        
        emailSignInView.signUpButton.rx.tap.subscribe { _ in
            let signUpVC1 = SignUpVC1()
            self.navigationController?.pushViewController(signUpVC1, animated: true)
        }

    }
}

