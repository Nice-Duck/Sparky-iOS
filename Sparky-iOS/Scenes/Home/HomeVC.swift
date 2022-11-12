//
//  HomeViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Moya

enum HomeSectionType: Int {
    case myScrap, otherScrap
}

enum ScrapLayoutStyle: Int {
    case halfOne = 1, halfTwo, horizontalOne, horizontalTwo, largeImage
}

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var myScrapViewModel = ScrapViewModel()
    private var otherScrapViewModel = ScrapViewModel()
    
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
        //        setupDelegate()
        createObserver()
        
        fetchScraps()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        fetchScraps()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func fetchScraps() {
        HomeServiceProvider.shared
            .getAllScraps()
            .map(ScrapResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    print("---홈 스크랩 요청 성공!!!---")
                    print("result - \(response.result)")
                    
                    if let result = response.result {
                        if let myScraps = result.myScraps {
                            myScraps.forEach { scrap in
                                var newTagList = [Tag]()
                                
                                scrap.tagsResponse?.forEach { tag in
                                    print("tag.color - \(tag.color)")
                                    let newTag = Tag(tagId: tag.tagId,
                                                     name: tag.name,
                                                     color: .colorchip12,
                                                     buttonType: .none)
                                    newTagList.append(newTag)
                                }
                                
                                let newScrap = Scrap(scrapId: scrap.scrapId,
                                                     title: scrap.title ?? "",
                                                     subTitle: scrap.subTitle ?? "",
                                                     memo: scrap.memo ?? "",
                                                     thumbnailURLString: scrap.imgUrl ?? "",
                                                     scrapURLString: scrap.scpUrl ?? "",
                                                     tagList: BehaviorRelay<[Tag]>(value: newTagList))
                                
                                self.myScrapViewModel.scraps.values.append(newScrap)
                            }
                        }
                        
                        if let recScraps = result.recScraps {
                            
                            recScraps.forEach { scrap in
                                var newTagList = [Tag]()
                                
                                scrap.tagsResponse?.forEach { tag in
                                    print("tag.color - \(tag.color)")
                                    let newTag = Tag(tagId: tag.tagId,
                                                     name: tag.name,
                                                     color: .colorchip12,
                                                     buttonType: .none)
                                    newTagList.append(newTag)
                                }
                                
                                let newScrap = Scrap(scrapId: scrap.scrapId,
                                                     title: scrap.title ?? "",
                                                     subTitle: scrap.subTitle ?? "",
                                                     memo: scrap.memo ?? "",
                                                     thumbnailURLString: scrap.imgUrl ?? "",
                                                     scrapURLString: scrap.scpUrl ?? "",
                                                     tagList: BehaviorRelay<[Tag]>(value: newTagList))
                                
                                self.otherScrapViewModel.scraps.values.append(newScrap)
                            }
                        }
                        print("myScrapViewModel - \(self.myScrapViewModel.scraps.value)")
                        print("otherScrapViewModel - \(self.otherScrapViewModel.scraps.value)")
                        print("reload!!!")
                        self.setupDelegate()
                        self.homeTableView.reloadData()
                    }
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
                                    self.fetchScraps()
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
                                    self.moveToSignInVC()
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
                                self.moveToSignInVC()
                            }
                        } onFailure: { error in
                            print("요청 실패 - \(error)")
                        }.disposed(by: self.disposeBag)
                } else {
                    print("response - \(response)")
                }
            } onFailure: { error in
                print("---홈 스크랩 요청 에러---")
                print("\(error)")
            }.disposed(by: disposeBag)
        
        //        print(myScrapViewModel.scraps.value)
        //        print(otherScrapViewModel.scraps.value)
        //        setupDelegate()
        //        homeTableView.reloadData()
        
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
                self.navigationController?.pushViewController(MyInfoVC(), animated: true)
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
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVC),
                                               name: SparkyNotification.showPreviewDetail,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVC),
                                               name: SparkyNotification.showPreviewWebView,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVC),
                                               name: SparkyNotification.showOtherDetail,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVC),
                                               name: SparkyNotification.showOtherWebView,
                                               object: nil)
    }
    
    private func moveToSignInVC() {
        guard let nc = self.navigationController else { return }
        var vcs = nc.viewControllers
        vcs = [SignInVC()]
        self.navigationController?.viewControllers = vcs
    }
    
    @objc private func showVC(notification: NSNotification) {
        if let scrap = notification.object {
            switch notification.name {
            case SparkyNotification.showPreviewDetail:
                let scrapDetailVC = ScrapDetailVC()
                scrapDetailVC.modalPresentationStyle = .overFullScreen
                scrapDetailVC.scrap = BehaviorRelay(value: scrap as! Scrap)
                navigationController?.pushViewController(scrapDetailVC, animated: false)
                break
            case SparkyNotification.showOtherDetail:
                let scrapDetailVC = OtherScrapDetailVC()
                scrapDetailVC.modalPresentationStyle = .overFullScreen
                scrapDetailVC.scrap = BehaviorRelay(value: scrap as! Scrap)
                navigationController?.pushViewController(scrapDetailVC, animated: false)
                break
            case SparkyNotification.showPreviewWebView, SparkyNotification.showOtherWebView:
                let scrapWebViewVC = ScrapWebViewVC()
                scrapWebViewVC.modalPresentationStyle = .overFullScreen
                scrapWebViewVC.urlString = (scrap as! Scrap).scrapURLString
                navigationController?.pushViewController(scrapWebViewVC, animated: false)
                break
            default:
                break
            }
        }
    }
}

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("myScrapViewModel1 - \(myScrapViewModel.scraps.value)")
        print("otherScrapViewModel1 - \(otherScrapViewModel.scraps.value)")
        
        let homeSectionType = HomeSectionType(rawValue: indexPath.section) ?? HomeSectionType.myScrap
        switch homeSectionType {
        case .myScrap:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MyScrapPreViewCollectionViewCell.identifier,
                for: indexPath) as! MyScrapPreViewCollectionViewCell
            cell.viewModel = myScrapViewModel
            cell.bindViewModel()
            return cell
        case .otherScrap:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OtherScrapCollectionViewCell.identifier,
                for: indexPath) as! OtherScrapCollectionViewCell
            cell.viewModel = otherScrapViewModel
            cell.bindViewModel()
            return cell
        }
    }
}

extension HomeVC: UITableViewDelegate {
    
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
            let share: CGFloat = CGFloat((241 + 138  + 270 + 48) * (otherScrapViewModel.scraps.value.count / 5))
            var remainder: CGFloat = 0
            let scrapLayoutStyle = ScrapLayoutStyle(rawValue: otherScrapViewModel.scraps.value.count % 5)
            
            switch scrapLayoutStyle {
            case .halfOne, .halfTwo:
                remainder = 241 + 12
            case .horizontalOne:
                remainder = 241 + 12 + 138 + 12
            case .horizontalTwo:
                remainder = 241 + 12 + 138 + 12 + 138 + 12
            case .largeImage:
                remainder = 241
            default:
                remainder = 0
            }
            return share + remainder
        }
    }
}
