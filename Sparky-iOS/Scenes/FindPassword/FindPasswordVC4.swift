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
        
        setupLottieView()
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
        nextButton.rx.tap.asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { _ in
                
                guard let email = self.email else { return }
                guard let password = self.password else { return }
                
                let emailSignInRequest = EmailSignInRequest(email: email,
                                                            pwd: password)
                
                self.lottieView.isHidden = false
                UserServiceProvider.shared
                    .patchPassword(emailSignInRequestModel: emailSignInRequest)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            self.lottieView.isHidden = true
                            print("요청 성공!!!")
                            MoveUtils().moveToSignInVC()
                        } else {
                            self.lottieView.isHidden = true
                            print("요청 실패!!!")
                        }
                    } onFailure: { error in
                        print("요청 실패!!! - \(error)")
                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
