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
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
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
        
        let navBarAddScrapButton = UIBarButtonItem(image: .addScrap,
                                                   style: .plain,
                                                   target: self,
                                                   action: nil)
        navBarAddScrapButton.rx.tap
            .subscribe { _ in
                
            }.disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = navBarAddScrapButton
    }
    
    private func setupConstraints() {
        
    }
}

