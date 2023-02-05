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
    case halfOne = 1, halfTwo = 2, horizontalOne = 3, horizontalTwo = 4, largeImage = 5
}

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var myScrapViewModel = ScrapViewModel()
    private var otherScrapViewModel = ScrapViewModel()
    
    private let refreshControl = UIRefreshControl().then {
        $0.addTarget(self,
                     action: #selector(refresh(_:)),
                     for: .valueChanged)
    }
    
    private let customActivityIndicatorView = CustomActivityIndicatorView().then {
        $0.loadingView.color = .white
        $0.backgroundColor = .gray700.withAlphaComponent(0.8)
    }
    
    private let scrapTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {
        $0.placeholder = "찾고싶은 스크랩의 키워드를 입력해주세요"
        $0.setupLeftImageView(image: .search.withRenderingMode(.alwaysTemplate))
        $0.clearButtonMode = .always
        $0.addTarget(self,
                     action: #selector(returnTabGesture),
                     for: .editingDidEndOnExit)
    }
    
    private let homeTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                            style: .grouped).then {
        $0.backgroundColor = .background
        $0.separatorInset = .zero
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(NoMyScrapViewCell.self,
                    forCellReuseIdentifier: NoMyScrapViewCell.identifier)
        $0.register(MyScrapPreViewCollectionViewCell.self,
                    forCellReuseIdentifier: MyScrapPreViewCollectionViewCell.identifier)
        $0.register(OtherScrapCollectionViewCell.self,
                    forCellReuseIdentifier: OtherScrapCollectionViewCell.identifier)
        $0.sectionFooterHeight = 0
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        
        if #available(iOS 15.0, *) {
            print("top padding - \($0.sectionHeaderTopPadding)")
            $0.sectionHeaderTopPadding = 0
        } else { }
    }
    
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
        setupLoadingView()
        createObserver()
        changeTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrapTextField.text = ""
        fetchScraps()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchScraps() {
        self.customActivityIndicatorView.isHidden = false
        self.customActivityIndicatorView.loadingView.startAnimating()
        HomeServiceProvider.shared
            .getAllScraps()
            .map(ScrapResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    self.customActivityIndicatorView.loadingView.stopAnimating()
                    self.customActivityIndicatorView.isHidden = true
                    
                    
                    print("---홈 스크랩 요청 성공!!!---")
                    print("result - \(response.result)")
                    
                    if let result = response.result {
                        if let myScraps = result.myScraps {
                            self.myScrapViewModel.scraps.values = []
                            
                            myScraps.forEach { scrap in
                                var newTagList = [Tag]()
                                
                                scrap.tagsResponse?.forEach { tag in
                                    print("tag.color - \(tag.color)")
                                    let newTag = Tag(tagId: tag.tagId,
                                                     name: tag.name,
                                                     color: UIColor(hexaRGB: tag.color ?? "#E6DBE0") ?? .colorchip1,
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
                            self.otherScrapViewModel.scraps.values = []
                            
                            recScraps.forEach { scrap in
                                var newTagList = [Tag]()
                                
                                scrap.tagsResponse?.forEach { tag in
                                    print("tag.color - \(tag.color)")
                                    let newTag = Tag(tagId: tag.tagId,
                                                     name: tag.name,
                                                     color: UIColor(hexaRGB: tag.color ?? "#E6DBE0") ?? .colorchip1,
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
                                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                                    
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
                                self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                                
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
                            self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                            print("요청 실패 - \(error)")
                        }.disposed(by: self.disposeBag)
                } else {
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    
                    print("response - \(response)")
                }
            } onFailure: { error in
                self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                print("---홈 스크랩 요청 에러---")
                print("\(error)")
            }.disposed(by: disposeBag)
    }
    
    private func setupNavBar() {
        let logoButtonItem = UIImageView(image: .logo)
        let profileButtonItem = UIBarButtonItem(image: .profile.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: nil)
        
        profileButtonItem.rx.tap
            .subscribe { _ in
                self.navigationController?.pushViewController(MyInfoVC(), animated: true)
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButtonItem)
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
        
        homeTableView.addSubview(refreshControl)
    }
    
    func setupLoadingView() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = scene?.windows.first {
            window.addSubview(customActivityIndicatorView)
            customActivityIndicatorView.snp.makeConstraints {
                $0.top.equalTo(window)
                $0.left.equalTo(window)
                $0.bottom.equalTo(window)
                $0.right.equalTo(window)
            }
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVC),
                                               name: SparkyNotification.showScrapShareVC,
                                               object: nil)
    }
    
    func changeTextField() {
        scrapTextField.rx.text
            .subscribe { _ in
                if let text = self.scrapTextField.text, text != "" {
                    
                } else {
                    
                }
            }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        fetchScraps()
        refreshControl.endRefreshing()
    }
    
    @objc private func returnTabGesture() {
        if let text = scrapTextField.text, text.count < 2 {
            return
        }
        
        let scrapSearchRequest = ScrapSearchRequest(tags: [],
                                                    title: scrapTextField.text ?? "",
                                                    type: 0)
        
        self.customActivityIndicatorView.isHidden = false
        self.customActivityIndicatorView.loadingView.startAnimating()
        HomeServiceProvider.shared
            .searchScrap(scrapSearchRequest: scrapSearchRequest)
            .map(ScrapSearchResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    self.customActivityIndicatorView.loadingView.stopAnimating()
                    self.customActivityIndicatorView.isHidden = true
                    
                    print("---return 버튼 클릭으로 검색 성공!!!---")
                    print("result - \(response.result)")
                    
                    if let result = response.result {
                        self.otherScrapViewModel.scraps.values = []
                        
                        result.forEach { scrap in
                            var newTagList = [Tag]()
                            
                            scrap.tagsResponse?.forEach { tag in
                                print("tag.color - \(tag.color)")
                                let newTag = Tag(tagId: tag.tagId,
                                                 name: tag.name,
                                                 color: UIColor(hexaRGB: tag.color ?? "#E6DBE0") ?? .colorchip1,
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
                                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                                    
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
                                self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                                
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
                            self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                            print("요청 실패 - \(error)")
                        }.disposed(by: self.disposeBag)
                } else {
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    
                    print("response - \(response)")
                }
            } onFailure: { error in
                self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                print("---홈 스크랩 요청 에러---")
                print("\(error)")
            }.disposed(by: disposeBag)
    }
    
    @objc private func showVC(notification: NSNotification) {
        if let scrap = notification.object {
            switch notification.name {
            case SparkyNotification.showPreviewDetail:
                let preViewScrapDetailVC = ScrapDetailVC()
                preViewScrapDetailVC.scrap = BehaviorRelay(value: scrap as! Scrap)
                preViewScrapDetailVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: preViewScrapDetailVC)
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: false)
                break
            case SparkyNotification.showOtherDetail:
                let otherScrapDetailVC = OtherScrapDetailVC()
                otherScrapDetailVC.scrap = BehaviorRelay(value: scrap as! Scrap)
                otherScrapDetailVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: otherScrapDetailVC)
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: false)
                break
            case SparkyNotification.showPreviewWebView, SparkyNotification.showOtherWebView:
                let scrapWebViewVC = ScrapWebViewVC()
                scrapWebViewVC.urlString = (scrap as! Scrap).scrapURLString
                scrapWebViewVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: scrapWebViewVC)
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: false)
                break
            default:
                break
            }
        } else {
            switch notification.name {
            case SparkyNotification.showScrapShareVC:
                let homeCustomShareVC = HomeCustomShareVC()
                let nav = UINavigationController(rootViewController: homeCustomShareVC)
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: false)
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
            if self.myScrapViewModel.scraps.value.count == 0 {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: NoMyScrapViewCell.identifier,
                    for: indexPath) as! NoMyScrapViewCell
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MyScrapPreViewCollectionViewCell.identifier,
                    for: indexPath) as! MyScrapPreViewCollectionViewCell
                cell.viewModel.scraps.values = self.myScrapViewModel.scraps.value
                cell.selectionStyle = .none
                return cell
            }
        case .otherScrap:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OtherScrapCollectionViewCell.identifier,
                for: indexPath) as! OtherScrapCollectionViewCell
            cell.viewModel.scraps.values = self.otherScrapViewModel.scraps.value
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension HomeVC: DismissVCDelegate {
    
    func sendNotification() {
        scrapTextField.text = ""
        self.fetchScraps()
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
            let share: CGFloat = CGFloat((241 + 138 + 138 + 270 + 48) * (otherScrapViewModel.scraps.value.count / 5))
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
                remainder = 241 + 12 + 138 + 12 + 138 + 12 + 270 + 12
            default:
                remainder = 0
            }
            return share + remainder
        }
    }
}
