//
//  SignUpVC3.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/27.
//

import UIKit
import RxSwift
import Lottie

class SignUpVC4: UIViewController {
    
    // MARK: - Properties
    var email: String? = nil
    var password: String? = nil
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    private let customActivityIndicatorView = CustomActivityIndicatorView().then {
        $0.loadingView.color = .sparkyWhite
        $0.backgroundColor = .gray700.withAlphaComponent(0.8)
      $0.isHidden = true
    }
    
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
    }
    
    private let keyboardBoxView = UIView()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLoadingView()
        createObserver()
        setupNavBar()
        setupUI()
        bindViewModel()
    }
    
    func setupLoadingView() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = scene?.windows.first {
            window.addSubview(customActivityIndicatorView)
            customActivityIndicatorView.snp.makeConstraints {
                $0.top.equalTo(window)
                $0.left.equalTo(window)
                $0.bottom.equalTo(window)
                $0.right.equalTo(window)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardBoxView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = keyboardSize.height - UIApplication.safeAreaInsetsBottom
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboardBoxView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = 0
            }
        }
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
        
        view.addSubview(keyboardBoxView)
        keyboardBoxView.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(0)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(keyboardBoxView.snp.top)
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
            .throttle(.seconds(3), latest: false)
            .drive { _ in
                self.nextButton.resignFirstResponder()
                
                guard let email = self.email else { print("Email is Null!"); return }
                guard let password = self.password else { print("Password is Null!"); return }
                guard let nickname = self.nicknameTextField.text else { print("Nickname is Null!"); return }

                print("email - \(email)")
                print("password - \(password)")
                print("nickname - \(nickname)")
                        
                self.customActivityIndicatorView.isHidden = false
                self.customActivityIndicatorView.loadingView.startAnimating()
                UserServiceProvider.shared
                    .signUpNicknameDuplicate(nickname: nickname)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
                            let signUpVC5 = SignUpVC5()
                            signUpVC5.signUpModel = SignUp(email: email,
                                                           password: password,
                                                           nickname: nickname)
                            self.navigationController?.pushViewController(signUpVC5, animated: true)
                        } else if response.code == "0001" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
                            self.nicknameTextField.layer.borderColor = UIColor.sparkyOrange.cgColor
                            self.errorLabel.text = response.message
                            self.errorLabel.isHidden = false
                        } else {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                        }
                    } onFailure: { error in
                        self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                        self.customActivityIndicatorView.loadingView.stopAnimating()
                        self.customActivityIndicatorView.isHidden = true
                        
                        print(error)
                    }.disposed(by: self.disposeBag)

            }.disposed(by: disposeBag)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
