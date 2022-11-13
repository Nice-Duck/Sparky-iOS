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
    var urlInputString: String?
    
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
        $0.addTarget(self,
                     action: #selector(textFieldChanged(sender:)),
                     for: UIControl.Event.editingChanged)
    }
    
    private let fetchButton = UIButton().then {
        $0.setTitle("불러오기", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        bindViewModel()
        setupDimmendTabGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showTagBottomSheet()
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
        
        let topConstant = view.safeAreaLayoutGuide.layoutFrame.height + view.safeAreaInsets.bottom
        tagBottomSheetTopConstraint = tagBottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        view.addSubview(tagBottomSheetView)
        tagBottomSheetTopConstraint.isActive = true
        tagBottomSheetView.snp.makeConstraints {
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
        
        tagBottomSheetView.addSubview(customNavBar)
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(tagBottomSheetView)
            $0.left.equalTo(tagBottomSheetView)
            $0.right.equalTo(tagBottomSheetView)
        }
        
        tagBottomSheetView.addSubview(plusURLTitleLabel)
        plusURLTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(12)
            $0.left.equalTo(tagBottomSheetView).offset(20)
        }
        
        tagBottomSheetView.addSubview(urlTextField)
        urlTextField.snp.makeConstraints {
            $0.top.equalTo(plusURLTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(41)
        }
        
        view.addSubview(fetchButton)
        fetchButton.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(20)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        fetchButton.rx.tap
            .subscribe { _ in
                self.dismissTagBottomSheetVC()
                
                let customShareVC = HomeCustomShareVC()
                if let urlInputString = self.urlInputString {
                    customShareVC.urlString = urlInputString
                } else {
                    customShareVC.urlString = self.urlTextField.text
                }
                let nav = UINavigationController(rootViewController: customShareVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }.disposed(by: disposeBag)
        
//        urlTextField.rx.text
//            .subscribe { _ in
//                <#code#>
//            } onError: { <#Error#> in
//                <#code#>
//            } onCompleted: {
//                <#code#>
//            } onDisposed: {
//                <#code#>
//            }

    }
    
    @objc private func textFieldChanged(sender: UITextField) {
        if let textFieldText = sender.text {
            urlInputString = textFieldText
        }
    }
    
    private func showTagBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let topPadding: CGFloat = view.safeAreaInsets.top
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        print("topPadding, bottomPadding - \(topPadding), \(bottomPadding)")
        
        tagBottomSheetTopConstraint.constant = (safeAreaHeight + 18) - defaultTagBottomSheetHeight
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
