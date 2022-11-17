//
//  SignUpVC5.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/13.
//

import UIKit
import RxSwift
import Lottie

class SignUpVC5: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var signUpModel: SignUp?
    
    private let customActivityIndicatorView = CustomActivityIndicatorView().then {
         $0.loadingView.color = .sparkyWhite
         $0.backgroundColor = .gray700.withAlphaComponent(0.8)
         $0.isHidden = true
    }
    
    let largeSizeView = UIView().then {
        $0.backgroundColor = .background2
    }
    
    let titleLabel = UILabel().then {
        $0.text = "회원가입이 완료되었습니다"
        $0.font = .headlineBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    let subTitleLabel = UILabel().then {
        $0.text = "이제 로그인하여 Sparky를 이용해보세요"
        $0.font = .bodyRegular2
        $0.textAlignment = .center
        $0.textColor = .gray700
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("Sparky 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .sparkyWhite
        
        setupLoadingView()
        setupConstraints()
        bindNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
    
    private func setupConstraints() {
        view.addSubview(largeSizeView)
        largeSizeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(260)
            $0.height.equalTo(260)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(largeSizeView.snp.bottom).offset(49)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe { _ in
                guard let signUpModel = self.signUpModel else { return }
                let emailSignUpRequest = EmailSignUpRequest(email: signUpModel.email,
                                                            pwd: signUpModel.password,
                                                            nickname: signUpModel.nickname)
                
                self.customActivityIndicatorView.isHidden = false
                self.customActivityIndicatorView.loadingView.startAnimating()
                UserServiceProvider.shared
                    .signUp(emailSignUpRequest: emailSignUpRequest)
                    .map(EmailSignUpResponse.self)
                    .subscribe { response in
                        
                        if response.code == "0000" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
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
                            MoveUtils.shared.moveToHomeVC(nav: self.navigationController)
                            
                        } else {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)

                            self.customActivityIndicatorView.loadingView.stopAnimating()
                            self.customActivityIndicatorView.isHidden = true
                            
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                        }
                    } onFailure: { error in
                        self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                        self.customActivityIndicatorView.loadingView.stopAnimating()
                        self.customActivityIndicatorView.isHidden = true
                        
                        print(error)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
}
