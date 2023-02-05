//
//  ScrapWebViewVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/04.
//

import UIKit
import WebKit
import RxSwift

class ScrapWebViewVC: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let webView = WKWebView()
    var urlString: String? = nil
    weak var dismissVCDelegate: DismissVCDelegate?
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        loadWebView()
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .gray100
        self.navigationController?.navigationBar.tintColor = .black
        
        let navBarBackButton = UIBarButtonItem(image: .clear,
                                               style: .plain,
                                               target: self,
                                               action: nil)
        navBarBackButton.rx.tap.subscribe { _ in
            self.dismiss(animated: true)
            self.dismissVCDelegate?.sendNotification()
        }.disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = navBarBackButton
        
        let navBarTitleLabel = UILabel().then {
            $0.text = "스크랩 상세"
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
                let homeCustomShareVC = HomeCustomShareVC()
                homeCustomShareVC.urlString = self.urlString
                homeCustomShareVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: homeCustomShareVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }.disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = navBarAddScrapButton
    }
    
    private func setupConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
    }
    
    private func loadWebView() {
        if let urlString = urlString {
            let request = URLRequest(url: URL(string: urlString) ?? URL(string: Strings.sparkyImageString)! )
            webView.load(request)
        }
    }
}

extension ScrapWebViewVC: DismissVCDelegate {
    func sendNotification() {
        self.dismiss(animated: false)
        self.dismissVCDelegate?.sendNotification()
    }
}
