//
//  SignUpVC1.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/27.
//


import UIKit
import RxSwift

class SignUpVC1: UIViewController {
    
    // MARK: - Properties
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    private let navigationEdgeBar = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "이메일을 입력해주세요"
        $0.font = .subTitleBold3
        $0.textColor = .sparkyBlack
    }
    
    private let emailTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "이메일을 입력해주세요",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
        $0.clearButtonMode = .whileEditing
    }
    
    private let errorLabel = UILabel().then {
        $0.text = "올바르지 않은 이메일 형식입니다."
        $0.font = .bodyRegular2
        $0.textColor = .sparkyOrange
        $0.isHidden = true
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("인증메일 받기", for: .normal)
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
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationEdgeBar.snp.bottom).offset(60)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(12)
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
    
    private func bindViewModel() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.valueObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .email)
            .map { $0 == .none ? UIColor.gray300.cgColor : $0 == .valid ? UIColor.sparkyBlack.cgColor : UIColor.sparkyOrange.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .email)
            .map { $0 == .none || $0 == .valid ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .email)
            .map { $0 == .none || $0 == .valid ? "" : "올바르지 않은 이메일 형식입니다." }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .email)
            .map{ $0 == .valid }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .email)
            .map { $0 == .valid ? .sparkyBlack : .gray300 }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver()
            .throttle(.seconds(3), latest: false)
            .drive { _ in
                guard let email = self.emailTextField.text else { return }
                UserServiceProvider.shared
                    .signUpEmailDuplicate(email: email)
                    .map(EmailSignUpResponse.self)
                    .subscribe { response in
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            let emailSendRequest = EmailSendRequest(email: email)
                            UserServiceProvider.shared
                                .signUpEmailSend(emailSendRequest: emailSendRequest)
                                .map(EmailSignUpResponse.self)
                                .subscribe { response in
                                    print("code - \(response.code)")
                                    print("message - \(response.message)")
                                    
                                    if response.code == "0000" {
                                        let signUpVC2 = SignUpVC2()
                                        signUpVC2.email = email
                                        self.navigationController?.pushViewController(signUpVC2, animated: true)
                                    }
                                } onFailure: { error in
                                    print(error)
                                }.disposed(by: self.disposeBag)
                        } else if response.code == "0001" {
                            self.emailTextField.layer.borderColor = UIColor.sparkyOrange.cgColor
                            self.errorLabel.text = response.message
                            self.errorLabel.isHidden = false
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        //            .bind(onNext: { _ in
        //                guard let email = self.emailTextField.text else { return }
        //                UserServiceProvider.shared
        //                    .signUpEmailDuplicate(email: email)
        //                    .map(EmailSignUpResponse.self)
        //                    .subscribe { response in
        //                        print("code - \(response.code)")
        //                        print("message - \(response.message)")
        //
        //                        if response.code == "0000" {
        //                            let emailSendRequest = EmailSendRequest(email: email)
        //                            UserServiceProvider.shared
        //                                .signUpEmailSend(emailSendRequest: emailSendRequest)
        //                                .map(EmailSignUpResponse.self)
        //                                .subscribe { response in
        //                                    print("code - \(response.code)")
        //                                    print("message - \(response.message)")
        //
        //                                    if response.code == "0000" {
        //                                        let signUpVC2 = SignUpVC2()
        //                                        signUpVC2.email = email
        //                                        self.navigationController?.pushViewController(signUpVC2, animated: true)
        //                                    }
        //                                } onFailure: { error in
        //                                    print(error)
        //                                }.disposed(by: self.disposeBag)
        //                        } else if response.code == "0001" {
        //                            self.emailTextField.layer.borderColor = UIColor.sparkyOrange.cgColor
        //                            self.errorLabel.text = response.message
        //                            self.errorLabel.isHidden = false
        //                        }
        //                    } onFailure: { error in
        //                        print(error)
        //                    }.disposed(by: self.disposeBag)
        //
        //            }).disposed(by: disposeBag)
        //        nextButton.rx.tap
        //            .bind { _ in
        //                let emailSendRequest = EmailSendRequest(email: email)
        //                UserServiceProvider.shared
        //                    .signUpEmailSend(emailSendRequest: emailSendRequest)
        //                    .map(EmailSignUpResponse.self)
        //                    .subscribe { response in
        //                        print("code - \(response.code)")
        //                        print("message - \(response.message)")
        //
        //                        if response.code == "0000" {
        //                            let signUpVC2 = SignUpVC2()
        //                            signUpVC2.email = email
        //                            self.navigationController?.pushViewController(signUpVC2, animated: true)
        //                        }
        //                    } onFailure: { error in
        //                        print(error)
        //                    }.disposed(by: self.disposeBag)
        //            }.disposed(by: disposeBag)
    }
    
    //    private func changeClearButtonImage() {
    //        let textField = self.emailTextField
    //        for subView in textField.subviews {
    //            if subView is UIButton {
    //                let button = subView as! UIButton
    //                let highlightedImage = UIImage()
    //                if let image = button.image(for: .highlighted) {
    ////                    highlightedImage = UIImage(
    //                }
    //            }
    //        }
    //    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
