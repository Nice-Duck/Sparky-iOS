//
//  FindPasswordVC4.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/16.
//

import UIKit
import RxSwift
import Lottie

class FindPasswordVC4: UIViewController {
    
    // MARK: - Properties
    var email: String?
    var password: String?
    var viewModel = SignUpViewModel()
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
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        title = "비밀번호 찾기"
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
            $0.width.equalTo(view.frame.width)
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
        nextButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe { _ in
                guard let email = self.email else { return }
                guard let password = self.password else { return }
                
                let emailSignInRequest = EmailSignInRequest(email: email,
                                                            pwd: password)
                
                self.customActivityIndicatorView.isHidden = false
                self.customActivityIndicatorView.loadingView.startAnimating()
                UserServiceProvider.shared
                    .patchPassword(emailSignInRequestModel: emailSignInRequest)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        self.resignFirstResponder()
                        
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
                            print("요청 성공!!!")
                            MoveUtils().moveToSignInVC(nav: self.navigationController)
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
