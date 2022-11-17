//
//  FindPasswordVC1.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

import UIKit
import RxSwift
import Lottie

class FindPasswordVC1: UIViewController {
    
    // MARK: - Properties
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
        title = "비밀 번호 찾기"
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
                self.emailTextField.resignFirstResponder()
                
                guard let email = self.emailTextField.text else { return }
                let emailSendRequest = EmailSendRequest(email: email)
                
                print("email - \(email)")
                
                self.customActivityIndicatorView.isHidden = false
                self.customActivityIndicatorView.loadingView.startAnimating()
                UserServiceProvider.shared
                    .signUpEmailSend(emailSendRequest: emailSendRequest)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
                            let findPasswordVC2 = FindPasswordVC2()
                            findPasswordVC2.email = email
                            self.navigationController?.pushViewController(findPasswordVC2, animated: true)
                        } else {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            print("요청 실패!!!")
                        }
                    } onFailure: { error in
                        self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                        self.customActivityIndicatorView.loadingView.stopAnimating()
                        self.customActivityIndicatorView.isHidden = true
                        
                        print("요청 실패!!! - \(error)")
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

