//
//  HomeViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa

enum HomeSectionType: Int {
    case myScrap, otherScrap
}

enum ScrapLayoutStyle: Int {
    case halfOne, halfTwo, horizontalOne, horizontalTwo, largeImage
}

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let scrapTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {
        
        $0.placeholder = "찾고싶은 스크랩의 키워드를 입력해주세요"
        $0.setupLeftImageView(image: UIImage(named: "search")!.withRenderingMode(.alwaysTemplate))
    }
    
    private let homeTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                            style: .grouped).then {
        $0.separatorInset = .zero
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .background
        $0.register(MyScrapPreViewCollectionViewCell.self,
                    forCellReuseIdentifier: MyScrapPreViewCollectionViewCell.identifier)
        $0.register(OtherScrapCollectionViewCell.self,
                    forCellReuseIdentifier: OtherScrapCollectionViewCell.identifier)
        $0.sectionFooterHeight = 0
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        } else { }
    }
    
    private let myScrapTitleLabel = UILabel().then({
        $0.text = "내 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    private let otherScrapTitleLabel = UILabel().then({
        $0.text = "다른 사람 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    private let otherScrapSubTitleLabel = UILabel().then({
        $0.text = "타 이용자가 저장한 콘텐츠를 추천해줍니다"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .gray600
    })
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        setupDelegate()
    }
    
    private func setupNavBar() {
        let logoButtonItem = UIBarButtonItem(image: UIImage(named: "logo")!.withRenderingMode(.alwaysOriginal),
                                             style: .done,
                                             target: self,
                                             action: nil)
        
        let profileButtonItem = UIBarButtonItem(image: UIImage(named: "profile")!.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: nil)
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
        
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom).offset(18)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
    }
    
    private func setupDelegate() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSectionType = HomeSectionType(rawValue: indexPath.section) ?? HomeSectionType.myScrap
        switch homeSectionType {
        case .myScrap:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MyScrapPreViewCollectionViewCell.identifier,
                for: indexPath)
            return cell
        case .otherScrap:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OtherScrapCollectionViewCell.identifier,
                for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let homeSectionType = HomeSectionType(rawValue: section) ?? HomeSectionType.myScrap
        switch homeSectionType {
        case .myScrap:
            return 34
        case .otherScrap:
            return 73
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let homeSectionType = HomeSectionType(rawValue: section) ?? HomeSectionType.myScrap
        switch homeSectionType {
        case .myScrap:
            return ScrapSectionView()
        case .otherScrap:
            return OtherScrapSectionView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let homeSectionType = HomeSectionType(rawValue: indexPath.section) ?? HomeSectionType.myScrap
        switch homeSectionType {
        case .myScrap:
            return 228
        case .otherScrap:
            return 900
        }
    }
}
