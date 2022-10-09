//
//  SignUpVC2.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/29.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC2: UIViewController {
    
    // MARK: - Properties
    var email: String? = nil
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    private let navigationEdgeBar = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let progressBar = UIView().then {
        $0.backgroundColor = .sparkyBlack
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "이메일 인증번호를 입력해주세요"
        $0.font = .subTitleBold3
        $0.textColor = .sparkyBlack
    }
    
    private let otpStackView = OTPStackView()
    
    private let errorLabel = UILabel().then {
        $0.text = "올바르지 않은 인증번호 형식입니다."
        $0.font = .bodyRegular2
        $0.textColor = .sparkyOrange
        $0.isHidden = true
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("인증 완료", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupUI()
        setupOTPView()
        bindViewModel()
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        title = "회원 가입"
        titleLabel.font = .subTitleBold1
    }
    
    private func setupUI() {
        view.addSubview(navigationEdgeBar)
        navigationEdgeBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(2)
        }
        
        navigationEdgeBar.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.top.equalTo(progressBar)
            $0.left.equalTo(progressBar)
            $0.height.equalTo(2)
            $0.width.equalTo(view.frame.size.width / 3)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationEdgeBar.snp.bottom).offset(60)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(otpStackView)
        otpStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(otpStackView.snp.bottom).offset(12)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func setupOTPView() {
        otpStackView.delegate = self
    }
    
    private func bindViewModel() {
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { _ in UIColor.sparkyOrange.cgColor
//            if $0 == .none {
//            for i in 0..<6 {
//                self.otpStackView.textFieldsCollection[i].layer.rx .borderColor = UIColor.sparkyOrange.cgColor
//            }
//        }
//            UIColor.gray300.cgColor : $0 == .invalid ? UIColor.sparkyOrange.cgColor : UIColor.sparkyBlack.cgColor
            
//        }.bind(to: otpStackView.rx.textFieldsCollection)
//                .bind(to: otpStackView.textFieldsCollection[0].layer.rx.borderColor)
//        .disposed(by: disposeBag)
        
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .none ? UIColor.gray300.cgColor : UIColor.orange.cgColor }
//        .bind(to: otpStackView.textFieldsCollection[1].layer.rx.borderColor)
//        .disposed(by: disposeBag)
//
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .none ? UIColor.gray300.cgColor : UIColor.sparkyBlack.cgColor }
//        .bind(to: otpStackView.textFieldsCollection[2].layer.rx.borderColor)
//        .disposed(by: disposeBag)
//
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .none ? UIColor.gray300.cgColor : UIColor.sparkyBlack.cgColor }
//        .bind(to: otpStackView.textFieldsCollection[3].layer.rx.borderColor)
//        .disposed(by: disposeBag)
//
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .none ? UIColor.gray300.cgColor : UIColor.sparkyBlack.cgColor }
//        .bind(to: otpStackView.textFieldsCollection[4].layer.rx.borderColor)
//        .disposed(by: disposeBag)
//
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .none ? UIColor.gray300.cgColor : UIColor.sparkyBlack.cgColor }
//        .bind(to: otpStackView.textFieldsCollection[5].layer.rx.borderColor)
//        .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .authNumber,
                          textFieldColection: otpStackView.textFieldsCollection)
        .map { $0 == .valid ? "" : "올바르지 않은 인증번호 형식입니다." }
        .bind(to: errorLabel.rx.text)
        .disposed(by: disposeBag)
        
//        viewModel.isValid(regexType: .authNumber,
//                          textFieldColection: otpStackView.textFieldsCollection)
//        .map { $0 == .valid ? true : false }
//        .bind(to: errorLabel.rx.isHidden)
//        .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .authNumber,
                          textFieldColection: otpStackView.textFieldsCollection)
        .map { $0 == .valid ? true : false }
        .bind(to: nextButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { _ in
                guard let email = self.email else{ print("Email is Null!"); return }
                print("입력 이메일 - \(email)")
                print("입력 인증 번호 - \(self.viewModel.inputNumberObserver.value)")
                
                let emailConfirmRequest = EmailConfirmRequest(email: email, number: self.viewModel.inputNumberObserver.value)
                UserServiceProvider.shared
                    .signUpEmailConfirm(emailConfirmRequest: emailConfirmRequest)
                    .map(EmailSignUpResponse.self)
                    .subscribe { response in
                        print("response \(response)")
                        print("code - \(response.code)")
                        print("message - \(response.message)")

                        if response.code == "0000" {
                            let signUpVC3 = SignUpVC3()
                            signUpVC3.email = self.email
                            self.navigationController?.pushViewController(signUpVC3, animated: true)
                        } else {
                            for textField in self.otpStackView.textFieldsCollection {
                                textField.layer.borderColor = UIColor.sparkyOrange.cgColor
                            }
                            self.errorLabel.text = response.message
                            self.errorLabel.isHidden = false
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: self.disposeBag)
                let signUpVC3 = SignUpVC3()
                signUpVC3.email = self.email
                self.navigationController?.pushViewController(signUpVC3, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupInvalid() {
        for textField in otpStackView.textFieldsCollection {
            textField.layer.borderColor = UIColor.sparkyOrange.cgColor
        }
        errorLabel.isHidden = false
    }
    
    func setupValid() {
        for textField in otpStackView.textFieldsCollection {
            textField.layer.borderColor = UIColor.sparkyBlack.cgColor
        }
        errorLabel.isHidden = true
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpVC2: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        //        if isValid {
        //            inputNumber = ""
        //            for i in 0..<otpStackView.textFieldsCollection.count {
        //                if let number = otpStackView.textFieldsCollection[i].text {
        //                    inputNumber += number
        //                }
        //            }
        //
        //            guard let email = email else { print("Empty Email!"); return }
        //            let emailConfirmRequest = EmailConfirmRequest(email: email, number: inputNumber)
        //            UserServiceProvider.shared
        //                .signUpConfirmSend(emailConfirmRequest: emailConfirmRequest)
        //                .map(EmailSignUpResponse.self)
        //                .subscribe { response in
        //                    print("code - \(response.code)")
        //                    print("message - \(response.message)")
        //                } onFailure: { error in
        //                    print(error)
        //                }.disposed(by: disposeBag)
        //        } else {
        //
        //        }
    }
}
