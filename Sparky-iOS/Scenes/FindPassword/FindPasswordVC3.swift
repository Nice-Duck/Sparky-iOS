//
//  FindPasswordVC3.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

import UIKit
import RxSwift
import Lottie

class FindPasswordVC3: UIViewController {
    
    // MARK: - Properties
    var email: String? = nil
    var viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    private let lottieView: LottieAnimationView = .init(name: "lottie").then {
        $0.loopMode = .loop
        $0.backgroundColor = .gray700.withAlphaComponent(0.8)
        $0.play()
        $0.isHidden = true
    }
    
    private let navigationEdgeBar = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let progressBar = UIView().then {
        $0.backgroundColor = .sparkyBlack
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "비밀번호를 입력해주세요"
        $0.font = .subTitleBold3
        $0.textColor = .sparkyBlack
    }
    
    private let passwordTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "비밀번호를 입력해주세요",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
        $0.clearButtonMode = .whileEditing
        $0.isSecureTextEntry = true
    }
    
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private let errorLabel = UILabel().then {
        $0.text = "올바르지 않은 비밀번호 형식입니다."
        $0.font = .bodyRegular2
        $0.textColor = .sparkyOrange
        $0.isHidden = true
    }
    
    private let conditionLabel = UILabel().then {
        $0.text = "영문/숫자포함 8~20자"
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
        
//        setupLottieView()
        createObserver()
        setupNavBar()
        setupUI()
        bindViewModel()
    }
    
    private func setupLottieView() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.windows.first?.addSubview(lottieView)
        lottieView.frame = self.view.bounds
        lottieView.center = self.view.center
        lottieView.contentMode = .scaleAspectFit
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
        title = "비밀번호 찾기"
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
            $0.width.equalTo(view.frame.size.width * 2 / 3)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationEdgeBar.snp.bottom).offset(60)
            $0.left.equalTo(view).offset(20)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(textStackView)
        textStackView.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
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
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.valueObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .password)
            .map { $0 == .none ? UIColor.gray300.cgColor : $0 == .valid ? UIColor.sparkyBlack.cgColor : UIColor.sparkyOrange.cgColor }
            .bind(to: passwordTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .password)
            .map { $0 == .none || $0 == .valid ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .password)
            .map { $0 == .valid }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid(regexType: .password)
            .map { $0 == .valid ? .sparkyBlack : .gray300 }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.passwordTextField.resignFirstResponder()
                
                guard let email = self.email else { return }
                guard let password = self.passwordTextField.text else { return }
                
                let findPasswordVC4 = FindPasswordVC4()
                findPasswordVC4.email = email
                findPasswordVC4.password = password
                self.navigationController?.pushViewController(findPasswordVC4, animated: true)
            }.disposed(by: disposeBag)
    }

    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

