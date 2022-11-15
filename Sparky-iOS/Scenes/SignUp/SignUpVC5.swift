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
    
    private let lottieView: LottieAnimationView = .init(name: "lottie").then {
        $0.loopMode = .loop
        $0.backgroundColor = .gray700.withAlphaComponent(0.8)
        $0.play()
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
        
        setupLottieView()
        setupConstraints()
        bindNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLottieView() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.windows.first?.addSubview(lottieView)
        lottieView.frame = self.view.bounds
        lottieView.center = self.view.center
        lottieView.contentMode = .scaleAspectFit
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
            .asDriver()
            .throttle(.seconds(3))
            .drive { _ in
                guard let signUpModel = signUpModel else { return }
                let emailSignUpRequest = EmailSignUpRequest(email: signUpModel.email,
                                                            pwd: signUpModel.password,
                                                            nickname: signUpModel.nickname)
                
                self.lottieView.isHidden = false
                UserServiceProvider.shared
                    .signUp(emailSignUpRequest: emailSignUpRequest)
                    .map(EmailSignUpResponse.self)
                    .subscribe { response in
                        
                        if response.code == "0000" {
                            self.lottieView.isHidden = true
                            
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
                            MoveUtils.shared.moveToHomeVC()
                            
                        } else {
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                        }
                    } onFailure: { error in
                        print(error)
                    }.disposed(by: self.disposeBag)
            }
    }
}
