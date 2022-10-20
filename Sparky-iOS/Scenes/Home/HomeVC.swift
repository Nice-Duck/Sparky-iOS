//
//  HomeViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeVC: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let scrapTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {

        $0.placeholder = "검색어를 입력해주세요"
        $0.setupLeftImageView(image: UIImage(named: "search")!)
        $0.leftView?.tintColor = .gray400
    }
    
    private let myScrapTitleLabel = UILabel().then({
        $0.text = "내 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
    }
    
    private func setupNavBar() {
        let logoButtonItem = UIBarButtonItem(image: UIImage(named: "logo"),
                                                style: .done,
                                                target: self,
                                                action: nil)
        logoButtonItem.tintColor = .sparkyBlack
        
        let profileButtonItem = UIBarButtonItem(image: UIImage(named: "profile"),
                                                 style: .plain,
                                                 target: self,
                                                 action: nil)
        profileButtonItem.tintColor = .none
        profileButtonItem.rx.tap
            .subscribe { _ in
                self.navigationController?.pushViewController(MyScrapVC(), animated: true)
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = logoButtonItem
        navigationItem.rightBarButtonItem = profileButtonItem
    }
    
    private func setupConstraints() {
        view.addSubview(scrapTextField)
        scrapTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        view.addSubview(myScrapTitleLabel)
        myScrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom).offset(18)
            $0.left.equalTo(view).offset(20)
        }
    }
}
