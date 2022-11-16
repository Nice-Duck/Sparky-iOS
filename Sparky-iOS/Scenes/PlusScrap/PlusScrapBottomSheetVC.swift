//
//  PlusScrapBottomSheetVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/02.
//

import UIKit
import RxSwift

class PlusScrapBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
//    var urlInputString: String?
    
    private let dimmedView =  UIView().then {
        $0.backgroundColor = .gray700
    }
    
    private let tagBottomSheetView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private var tagBottomSheetTopConstraint: NSLayoutConstraint!
    private let defaultTagBottomSheetHeight: CGFloat = 260
    
    private let customNavBar = SparkyNavBar().then {
        $0.backgroundColor = .white
        $0.tintColor = .sparkyBlack
        $0.isTranslucent = false
        $0.shadowImage = UIImage()
    }
    private let customNavItem = UINavigationItem()
    
    private let navTitleLabel = UILabel().then {
        $0.text = "스크랩 추가"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let navCancelButtonItem = UIBarButtonItem().then {
        $0.image = UIImage(named: "back")
        $0.style = .plain
    }
    
    private let plusStackVuew = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let plusURLTitleLabel = UILabel().then {
        $0.text = "스크랩 URL"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let urlTextField = UITextField().then {
        $0.font = .bodyRegular2
        $0.textColor = .sparkyBlack
        $0.attributedPlaceholder(text: "URL주소를 입력해주세요",
                                 color: .gray400,
                                 font: .bodyRegular2)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.cornerRadius = 8
        $0.setLeftPadding(20)
        $0.clearButtonMode = .whileEditing
    }
    
    private let noDataTextLabel = UILabel().then {
        $0.text = "스크랩 정보를 가져올 수 없습니다."
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyOrange
        $0.isHidden = true
    }
    
    private let fetchButton = UIButton().then {
        $0.setTitle("불러오기", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
    }
    
    private let keyboardBoxView = UIView().then {
        $0.backgroundColor = .gray700
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        createObserver()
        setupNavBar()
        setupConstraints()
        bindViewModel()
        setupDimmendTabGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showTagBottomSheet()
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
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            self.keyboardBoxView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = keyboardSize.height - UIApplication.safeAreaInsetsBottom - 49
                    tagBottomSheetTopConstraint.constant = safeAreaHeight - defaultTagBottomSheetHeight - constraint.constant
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboardBoxView.constraints.forEach { constraint in
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            if constraint.firstAttribute == .height {
                constraint.constant = 0
                tagBottomSheetTopConstraint.constant = safeAreaHeight - defaultTagBottomSheetHeight
            }
        }
    }
    
    class CustomUITextField: UITextField {
       override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return true
            }
            return super.canPerformAction(action, withSender: sender)
       }
    }
    
    private func setupNavBar() {
        navCancelButtonItem.rx.tap.subscribe { _ in
            self.dismissTagBottomSheetVC()
        }.disposed(by: disposeBag)
        
        customNavItem.titleView = navTitleLabel
        customNavItem.leftBarButtonItem = navCancelButtonItem
        customNavBar.setItems([customNavItem], animated: false)
    }
    
    private func setupConstraints() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
        
        view.addSubview(keyboardBoxView)
        keyboardBoxView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0)
        }
        
        let topConstant = view.safeAreaLayoutGuide.layoutFrame.height + view.safeAreaInsets.bottom
        tagBottomSheetTopConstraint = tagBottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        view.addSubview(tagBottomSheetView)
        tagBottomSheetTopConstraint.isActive = true
        tagBottomSheetView.snp.makeConstraints {
            $0.left.equalTo(view)
            $0.bottom.equalTo(keyboardBoxView.snp.top)
            $0.right.equalTo(view)
        }
        
        tagBottomSheetView.addSubview(customNavBar)
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(tagBottomSheetView)
            $0.left.equalTo(tagBottomSheetView)
            $0.right.equalTo(tagBottomSheetView)
        }
        
        tagBottomSheetView.addSubview(plusStackVuew)
        plusStackVuew.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(12)
            $0.left.equalTo(tagBottomSheetView).offset(20)
        }
        
        plusStackVuew.addArrangedSubview(plusURLTitleLabel)
        plusStackVuew.addArrangedSubview(urlTextField)

        urlTextField.snp.makeConstraints {
            $0.top.equalTo(plusURLTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(41)
        }
        
        plusStackVuew.addArrangedSubview(noDataTextLabel)
        
        tagBottomSheetView.addSubview(fetchButton)
        fetchButton.snp.makeConstraints {
            $0.top.equalTo(plusStackVuew.snp.bottom).offset(20)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        urlTextField.rx.text
            .subscribe { _ in
                print("urlstring - \(self.urlTextField.text)")
                
                if self.urlTextField.text == "" {
                    self.fetchButton.isEnabled = false
                    self.fetchButton.backgroundColor = .gray300
                    self.urlTextField.layer.borderColor = UIColor.gray300.cgColor
                    self.noDataTextLabel.isHidden = true
                } else {
                    self.fetchButton.isEnabled = true
                    self.fetchButton.backgroundColor = .sparkyBlack
                    self.urlTextField.layer.borderColor = UIColor.sparkyBlack.cgColor
                    self.urlTextField.textColor = .sparkyBlack
                    self.noDataTextLabel.isHidden = true
                }
            }.disposed(by: disposeBag)
        
        fetchButton.rx.tap
            .subscribe { _ in
//                self.dismissTagBottomSheetVC()
//                self.urlTextField.resignFirstResponder()
                
                if let urlStringText = self.urlTextField.text {
                    self.validateURL(urlStringText: urlStringText)
//                    self.dismissTagBottomSheetVC()
//                    self.urlTextField.resignFirstResponder()
                }
            }.disposed(by: disposeBag)
    }
    
    private func validateURL(urlStringText: String) {
        HomeServiceProvider.shared
            .validateURL(urlString: urlStringText)
            .map(PostResultResponse.self)
            .subscribe { [weak self] response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                guard let self = self else { return }
                
                if response.code == "0000" {
                    let customShareVC = HomeCustomShareVC()
                        customShareVC.urlString = urlStringText

                    let nav = UINavigationController(rootViewController: customShareVC)
                    nav.modalPresentationStyle = .fullScreen
//                    self.dismissTagBottomSheetVC()
//                    self.urlTextField.resignFirstResponder()
                    self.present(nav, animated: true)
                } else if response.code == "F002" {
                    self.fetchButton.isEnabled = false
                    self.fetchButton.backgroundColor = .gray300
                    self.urlTextField.layer.borderColor = UIColor.gray300.cgColor
                    self.noDataTextLabel.isHidden = false
                } else if response.code == "U000" {
                    print("error response - \(response)")
                    
                    if let _ = TokenUtils().read("com.sparky.token", account: "accessToken") {
                        TokenUtils().delete("com.sparky.token", account: "accessToken")
                    }
                    
                    ReIssueServiceProvider.shared
                        .reissueAccesstoken()
                        .map(ReIssueTokenResponse.self)
                        .subscribe { response in
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                            
                            if response.code == "0000" {
                                print("요청 성공!!! - 토큰 재발급")
                                if let result = response.result {
                                    TokenUtils().create("com.sparky.token", account: "accessToken", value: result.accessToken)
                                    self.validateURL(urlStringText: urlStringText)
                                } else {
                                    print(response.code)
                                    print("message - \(response.message)")
                                    print("토큰 재발급 실패!!")
                                    
                                    if let _ = TokenUtils().read("com.sparky.token", account: "accessToken") {
                                        TokenUtils().delete("com.sparky.token", account: "accessToken")
                                    }
                                    
                                    if let _ = TokenUtils().read("com.sparky.token", account: "refreshToken") {
                                        TokenUtils().delete("com.sparky.token", account: "refreshToken")
                                    }
                                    MoveUtils.shared.moveToSignInVC(nav: self.navigationController)
                                }
                            } else {
                                print(response.code)
                                print("message - \(response.message)")
                                print("토큰 재발급 실패!!")
                                
                                if let _ = TokenUtils().read("com.sparky.token", account: "accessToken") {
                                    TokenUtils().delete("com.sparky.token", account: "accessToken")
                                }
                                
                                if let _ = TokenUtils().read("com.sparky.token", account: "refreshToken") {
                                    TokenUtils().delete("com.sparky.token", account: "refreshToken")
                                }
                                MoveUtils.shared.moveToSignInVC(nav: self.navigationController)
                            }
                        } onFailure: { error in
                            print("요청 실패 - \(error)")
                        }.disposed(by: self.disposeBag)
                } else {
                    print("response - \(response)")
                }
            } onFailure: { error in
                print("요청 실패!!! - \(error)")
            }.disposed(by: self.disposeBag)
    }
    
    private func showTagBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let topPadding: CGFloat = view.safeAreaInsets.top
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        print("topPadding, bottomPadding - \(topPadding), \(bottomPadding)")
        
        tagBottomSheetTopConstraint.constant = safeAreaHeight - defaultTagBottomSheetHeight
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    private func setupDimmendTabGesture() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: nil)
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        dimmedTap.rx.event.subscribe { _ in
            self.dismissTagBottomSheetVC()
        }.disposed(by: disposeBag)
    }
    
    private func dismissTagBottomSheetVC() {
        urlTextField.text = ""
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = self.view.safeAreaInsets.bottom
        self.tagBottomSheetTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { self.view.layoutIfNeeded() }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
