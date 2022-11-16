//
//  MyInfoVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import UIKit
import RxSwift

class MyInfoVC: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let profileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    let profileImageView = UIImageView().then {
        $0.image = .ellipse5
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "나이스덕"
        $0.font = .bodyBold2
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    let myInfoTableView = UITableView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 8
        $0.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        $0.isScrollEnabled = false
        $0.sectionHeaderHeight = 0
        $0.sectionFooterHeight = 0
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        $0.register(MyInfoTableViewCell.self,
                    forCellReuseIdentifier: MyInfoTableViewCell.identifier)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        setupDelegate()
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .background
        self.navigationController?.navigationBar.tintColor = .black
        
        let navBarBackButton = UIBarButtonItem(image: UIImage(named: "back"),
                                               style: .plain,
                                               target: self,
                                               action: nil)
        navBarBackButton.rx.tap.subscribe { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = navBarBackButton
        
        let navBarTitleLabel = UILabel().then {
            $0.text = "마이페이지"
            $0.font = .subTitleBold1
            $0.textAlignment = .center
            $0.textColor = .sparkyBlack
        }
        self.navigationItem.titleView = navBarTitleLabel
    }
    
    private func setupConstraints() {
        view.addSubview(profileStackView)
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerX.equalTo(view)
        }
        
        profileStackView.addArrangedSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(84)
            $0.height.equalTo(84)
        }
        
        profileStackView.addArrangedSubview(nicknameLabel)
        
        view.addSubview(myInfoTableView)
        myInfoTableView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(24)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(323)
        }
    }
    
    private func setupDelegate() {
        myInfoTableView.dataSource = self
        myInfoTableView.delegate = self
    }
    
    private func deleteProfile() {
        HomeServiceProvider.shared
            .signOut()
            .map(PostResultResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    print("회원 탈퇴 성공!!!")
                    TokenUtils().delete("com.sparky.token", account: "accessToken")
                    TokenUtils().delete("com.sparky.token", account: "refreshToken")
                    MoveUtils.shared.moveToSignInVC(nav: self.navigationController)
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
                                    self.deleteProfile()
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
            }.disposed(by: disposeBag)
    }
}

extension MyInfoVC: CustomPopUpDelegate {
    func action() {
        deleteProfile()
    }
    
    func exit() {
        
    }
}

extension MyInfoVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyInfoTableViewCell.identifier,
            for: indexPath) as! MyInfoTableViewCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
//            cell.rightChevronImageView.isHidden = false
//
//            if indexPath.row == 0 {
//                cell.actionLabel.text = "프로필 설정"
//            } else if indexPath.row == 1 {
//                cell.actionLabel.text = "내 태그 목록"
//            } else {
//                cell.actionLabel.text = "서비스 환경설정"
//            }
//        } else if indexPath.section == 1 {
            cell.rightChevronImageView.isHidden = true
            
            if indexPath.row == 0 {
//                cell.actionLabel.text = "문의하기"
//            } else if indexPath.row == 1 {
//                cell.actionLabel.text = "프로필 공유하기"
//            } else {
                cell.actionLabel.text = "로그아웃"
            }
        } else {
            cell.rightChevronImageView.isHidden = true
            cell.actionLabel.text = "탈퇴하기"
            cell.actionLabel.textColor = .sparkyOrange
        }
        return cell
    }
}

extension MyInfoVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                TokenUtils().delete("com.sparky.token", account: "accessToken")
                TokenUtils().delete("com.sparky.token", account: "refreshToken")
                MoveUtils.shared.moveToSignInVC(nav: self.navigationController)
            }
        } else if indexPath.section == 1 {
            let customPopUpVC = CustomPopUpVC()
            customPopUpVC.setupValue(title: "탈퇴 하시겠습니까?",
                                     cancelText: "취소하기",
                                     confirmText: "탈퇴하기")
            customPopUpVC.modalPresentationStyle = .overFullScreen
            customPopUpVC.customPopUpDelegate = self
            present(customPopUpVC, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}
