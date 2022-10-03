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

//    private let emailTextField = UITextField().then {
//        $0.font = .bodyRegular2
//        $0.textColor = .sparkyBlack
//        $0.attributedPlaceholder(text: "이메일을 입력해주세요",
//                                 color: .gray400,
//                                 font: .bodyRegular2)
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor.gray300.cgColor
//        $0.layer.cornerRadius = 8
//        $0.setLeftPadding(20)
//        $0.clearButtonMode = .whileEditing
//    }
    
    private let otpStackView = OTPStackView()
//        .then {
//        $0.showsWarningColor = true
//        $0.setAllFieldColor(color: .sparkyBlack)
//    }
    
    private let errorLabel = UILabel().then {
        $0.text = "한굴, 영어, 숫자로 2~16글자"
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("인증 완료", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
//        $0.addTarget(self,
//                     action: #selector(didTapNextButton),
//                     for: .touchUpInside)
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
    
    private func bindViewModel() {
//        otpStackView.textFieldsCollection[0].
//
//            .bind(to: viewModel.valueObserver)
//            .disposed(by: disposeBag)
        
//        viewModel.isValid(regexType: .email)
//            .bind(to: nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
//        viewModel.isEmpty(regexType: .email)
//            .map { $0 ? UIColor.gray300.cgColor : UIColor.sparkyOrange.cgColor }
//            .bind(to: emailTextField.layer.rx.borderColor)
//            .disposed(by: disposeBag)
//
//        viewModel.isEmpty(regexType: .email)
//            .map { $0 ? true : false }
//            .bind(to: conditionLabel.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        viewModel.isValid(regexType: .email)
//            .map { $0 ? .black : .gray300 }
//            .bind(to: nextButton.rx.backgroundColor)
//            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { _ in
                let signUpVC3 = SignUpVC3()
                self.navigationController?.pushViewController(signUpVC3, animated: true)
            }.disposed(by: disposeBag)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
