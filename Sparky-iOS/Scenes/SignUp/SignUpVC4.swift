//
//  SignUpVC3.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/27.
//

import UIKit
import RxSwift

class SignUpVC4: UIViewController {
    
    // MARK: - Properties
    var email: String? = nil
    var password: String? = nil
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    private let navigationEdgeBar = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let progressBar = UIView().then {
        $0.backgroundColor = .sparkyBlack
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.font = .subTitleBold3
        $0.textColor = .sparkyBlack
    }
    
    private let nicknameTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "닉네임을 입력해주세요",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
        $0.clearButtonMode = .whileEditing
    }
    
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private let errorLabel = UILabel().then {
        $0.text = "올바르지 않은 닉네임 형식입니다."
        $0.font = .bodyRegular2
        $0.textColor = .sparkyOrange
        $0.isHidden = true
    }
    
    private let conditionLabel = UILabel().then {
        $0.text = "한글, 영어, 숫자 2~16자"
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
//        $0.setKeyboardObserver()
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupUI()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
            $0.top.equalTo(progressBar.snp.top)
            $0.left.equalTo(progressBar.snp.left)
            $0.height.equalTo(2)
            $0.width.equalTo(view.frame.size.width)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationEdgeBar.snp.bottom).offset(60)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(textStackView)
        textStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            $0.left.equalTo(view).offset(20)
        }
        
        textStackView.addArrangedSubview(errorLabel)
        textStackView.addArrangedSubview(conditionLabel)
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        nicknameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.valueObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .nickname)
            .map { $0 == .none ? UIColor.gray300.cgColor : $0 == .valid ? UIColor.sparkyBlack.cgColor : UIColor.sparkyOrange.cgColor }
            .bind(to: nicknameTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .nickname)
            .map { $0 == .none || $0 == .valid ? "" : "올바르지 않은 닉네임 형식입니다." }
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .nickname)
            .map { $0 == .none || $0 == .valid ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .nickname)
            .map { $0 == .valid }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .nickname)
            .map { $0 == .valid ? .sparkyBlack : .gray300 }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver()
            .throttle(.seconds(5), latest: false)
            .drive { _ in
                guard let email = self.email else { print("Email is Null!"); return }
                guard let password = self.password else { print("Password is Null!"); return }
                guard let nickname = self.nicknameTextField.text else { print("Nickname is Null!"); return }

                print("email - \(email)")
                print("password - \(password)")
                print("nickname - \(nickname)")
                
                let nicknameDuplicateRequest = EmailNicknameDuplicateRequest(name: nickname)
                UserServiceProvider.shared
                    .signUpNicknameDuplicate(nicknameDuplicateRequest: nicknameDuplicateRequest)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            let emailSignUpRequest = EmailSignUpRequest(email: email, pwd: password, nickname: nickname)
                            UserServiceProvider.shared
                                .signUp(emailSignUpRequest: emailSignUpRequest)
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
                                        }
                                        self.moveToHomeVC()
                                        
                                    } else if response.code == "0001" {
                                        self.nicknameTextField.layer.borderColor = UIColor.sparkyOrange.cgColor
                                        self.errorLabel.text = response.message
                                        self.errorLabel.isHidden = false
                                    } else {
                                        print("code - \(response.code)")
                                        print("message - \(response.message)")
                                    }
                                } onFailure: { error in
                                    print(error)
                                }.disposed(by: self.disposeBag)
                        } else if response.code == "0001" {
                            self.nicknameTextField.layer.borderColor = UIColor.sparkyOrange.cgColor
                            self.errorLabel.text = response.message
                            self.errorLabel.isHidden = false
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: self.disposeBag)

            }.disposed(by: disposeBag)
    }
    
    private func moveToHomeVC() {
        guard let nc = self.navigationController else { return }
        var vcs = nc.viewControllers
        vcs = [HomeVC()]
        self.navigationController?.viewControllers = vcs
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
