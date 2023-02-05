//
//  MyScrapVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import UIKit
import RxSwift
import RxRelay
import Lottie

enum SetViewButtonType {
    case horizontal, largeImage
}

final class MyScrapVC: UIViewController {
    
    // MARK: - Properties
    private let filterTagViewModel = MyScrapFilterViewModel()
    private let scrapViewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    private var selectedButtonType = BehaviorRelay<SetViewButtonType>(value: SetViewButtonType.horizontal)
    private var filterTagIdList = [Int]()
    
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
        
        $0.placeholder = "검색어를 입력해주세요"
        $0.setupLeftImageView(image: .search.withRenderingMode(.alwaysTemplate))
        $0.addTarget(self,
                     action: #selector(returnTabGesture),
                     for: .editingDidEndOnExit)
    }
    
    private let filterTagCollectionView = TagCollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: TagCollectionViewFlowLayout()).then {
            $0.backgroundColor = .background
        }
    
    private let myScrapSectionView = MyScrapSectionView()
    
    private let myScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        //        flowlayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 40, height: 138)
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 12
        flowlayout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.backgroundColor = .background
        cv.layer.cornerRadius = 8
        cv.showsVerticalScrollIndicator = false
        cv.register(MyHorizontalLayoutCell.self,
                    forCellWithReuseIdentifier: MyHorizontalLayoutCell.identifier)
        cv.register(MyLargeImageLayoutCell.self,
                    forCellWithReuseIdentifier: MyLargeImageLayoutCell.identifier)
        cv.register(MyScrapSectionView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: MyScrapSectionView.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        setupLoadingView()
        setupDelegate()
        bindViewModel()
        createObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrapTextField.text = ""
        filterTagViewModel.filterTagList.values = [Tag(tagId: -1,
                                                      name: "필터",
                                                      color: .sparkyOrange,
                                                      buttonType: .add)]
        fetchScraps()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func fetchScraps() {
        self.customActivityIndicatorView.isHidden = false
        self.customActivityIndicatorView.loadingView.startAnimating()
        HomeServiceProvider.shared
            .getMyScraps()
            .map(ScrapResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                self.customActivityIndicatorView.isHidden = false
                self.customActivityIndicatorView.loadingView.startAnimating()
                if response.code == "0000" {
                    self.customActivityIndicatorView.loadingView.stopAnimating()
                    self.customActivityIndicatorView.isHidden = true

                    print("---마이 스크랩 요청 성공!!!---")
                    print("result - \(response.result)")
                    
                    if let result = response.result {
                        if let myScraps = result.myScraps {
                            self.scrapViewModel.scraps.values = []
                            
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
                                
                                self.scrapViewModel.scraps.values.append(newScrap)
                            }
                        }
                        print("myScrapViewModel - \(self.scrapViewModel.scraps.value)")
                        print("otherScrapViewModel - \(self.scrapViewModel.scraps.value)")
                        self.setupData()
                        self.setupDelegate()
                        self.myScrapCollectionView.reloadData()
                    }
                } else if response.code == "U000" {
                    print("response - \(response)")
                    
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
        navigationItem.title = "내 스크랩"
    }
    
    private func setupConstraints() {
        view.addSubview(scrapTextField)
        scrapTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        view.addSubview(filterTagCollectionView)
        filterTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom).offset(12)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(24)
        }
        
        view.addSubview(myScrapSectionView)
        myScrapSectionView.snp.makeConstraints {
            $0.top.equalTo(filterTagCollectionView.snp.bottom).offset(8)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(24)
        }
        
        view.addSubview(myScrapCollectionView)
        myScrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(myScrapSectionView.snp.bottom).offset(18)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
        
        myScrapCollectionView.addSubview(refreshControl)
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
        myScrapCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        myScrapCollectionView.dataSource = nil
        
        filterTagViewModel.filterTagList
            .bind(to: filterTagCollectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCollectionViewCell.identifier,
                    for: indexPath) as! TagCollectionViewCell
                cell.setupConstraints()
                
                let tag = self.filterTagViewModel.filterTagList.value[row]
                cell.setupTagButton(tag: tag, actionType: .search)
                return cell
                
            }.disposed(by: disposeBag)
        
        scrapViewModel.scraps.bind(to: myScrapCollectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            switch self.selectedButtonType.value {
            case .horizontal:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyHorizontalLayoutCell.identifier,
                    for: indexPath) as! MyHorizontalLayoutCell
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 8
                cell.setupValue(scrap: self.scrapViewModel.scraps.value[row])
                
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.scrapViewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupTagButton(tag: tag, actionType: .display)
                    }.disposed(by: self.disposeBag)
                cell.scrapDetailButton.tag = row
                cell.thumbnailImageView.tag = row
                return cell
                
            case .largeImage:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyLargeImageLayoutCell.identifier,
                    for: indexPath) as! MyLargeImageLayoutCell
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 8
                cell.setupValue(scrap: self.scrapViewModel.scraps.value[row])
                
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.scrapViewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupTagButton(tag: tag, actionType: .display)
                    }.disposed(by: self.disposeBag)
                cell.scrapDetailButton.tag = row
                cell.thumbnailImageView.tag = row
                return cell
            }
        }.disposed(by: disposeBag)
        
        myScrapSectionView.setHorizontalViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setHorizontalViewButton.tintColor = .sparkyBlack
                self.myScrapSectionView.setLargeImageViewButton.tintColor = .gray400
                self.selectedButtonType = BehaviorRelay(value: SetViewButtonType.largeImage)
                self.scrapViewModel.scraps.accept(self.scrapViewModel.scraps.value)
            }.disposed(by: disposeBag)
        myScrapSectionView.setLargeImageViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setLargeImageViewButton.tintColor = .sparkyBlack
                self.myScrapSectionView.setHorizontalViewButton.tintColor = .gray400
                self.selectedButtonType = BehaviorRelay(value: SetViewButtonType.horizontal)
                self.scrapViewModel.scraps.accept(self.scrapViewModel.scraps.value)
            }.disposed(by: disposeBag)
        
        filterTagCollectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                if self.filterTagViewModel.filterTagList.value.count > 0 {
                    switch indexPath.row {
                    case 0:
                        self.presentTagBottomSheetVC()
                        break
                        
                    default:
                        self.filterTagIdList.remove(at: indexPath.row - 1)
                        self.filterTagViewModel.filterTagList.remove(at: indexPath.row)
                        
                        let scrapSearchRequest = ScrapSearchRequest(
                            tags: self.filterTagIdList,
                            title: self.scrapTextField.text ?? "",
                            type: 1)
                        self.searchScrap(scrapSearchRequest: scrapSearchRequest)
                        break
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func presentTagBottomSheetVC() {
        let tagBottomSheetVC = HomeTagBottomSheetVC()
        tagBottomSheetVC.newTagCVDelegate = self
        tagBottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(tagBottomSheetVC, animated: false)
    }
    
    private func setupData() {
        myScrapSectionView.totalCountLabel.text = "총 \(scrapViewModel.scraps.value.count)개"
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrap),
                                               name: SparkyNotification.sendMyScrapDetailIndex,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrap),
                                               name: SparkyNotification.sendMyScrapWebViewIndex,
                                               object: nil)
    }
    
    private func searchScrap(scrapSearchRequest: ScrapSearchRequest) {
        print("scrapSearchRequest - \(scrapSearchRequest)")
        
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
                    
                    print("---검색 성고오옹!!!---")
                    print("result - \(response.result)")
                    
                    if let result = response.result {
                        self.scrapViewModel.scraps.values = []
                        
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
                            
                            self.scrapViewModel.scraps.values.append(newScrap)
                        }
                        print("myScrapViewModel - \(self.scrapViewModel.scraps.value)")
                        print("otherScrapViewModel - \(self.scrapViewModel.scraps.value)")
                        print("reload!!!")
                        self.setupData()
                        self.setupDelegate()
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
                print("--- 서치 요청 에러---")
                print("\(error)")
            }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        fetchScraps()
        refreshControl.endRefreshing()
    }
    
    @objc private func returnTabGesture() {
        if let text = scrapTextField.text, text.count < 2 {
            let window = UIKitUtils.parentWindow
            window?.makeToast("2글자 이상 입력해주세요.")
            return
        }
        
        let scrapSearchRequest = ScrapSearchRequest(tags: filterTagIdList,
                                                    title: scrapTextField.text ?? "",
                                                    type: 1)
        searchScrap(scrapSearchRequest: scrapSearchRequest)
    }
    
    @objc private func showScrap(notification: NSNotification) {
        switch notification.name {
        case SparkyNotification.sendMyScrapDetailIndex:
            if let index = notification.object {
                let scrapDetailVC = ScrapDetailVC()
                scrapDetailVC.scrap = BehaviorRelay(value: scrapViewModel.scraps.value[index as! Int])
                print("showScrap scrap - \(scrapDetailVC.scrap)")
                scrapDetailVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: scrapDetailVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
            break
        case SparkyNotification.sendMyScrapWebViewIndex:
            if let index = notification.object {
                let scrapWebViewVC = ScrapWebViewVC()
                scrapWebViewVC.modalPresentationStyle = .overFullScreen
                scrapWebViewVC.urlString = scrapViewModel.scraps.value[index as! Int].scrapURLString
                scrapWebViewVC.dismissVCDelegate = self
                let nav = UINavigationController(rootViewController: scrapWebViewVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
            break
        default:
            break
        }
    }
}

extension MyScrapVC: NewTagCVDelegate {
    func sendNewTagList(tag: Tag) {
        let newTag = Tag(tagId: tag.tagId,
                         name: tag.name,
                         color: tag.color,
                         buttonType: .delete)
        
        if !filterTagViewModel.filterTagList.value.contains(where: { tag in
            if tag == newTag {
                return true
            }
            return false
        }) {
            filterTagViewModel.filterTagList.append(newTag)
            filterTagIdList.append(newTag.tagId)
            
            let scrapSearchRequest = ScrapSearchRequest(
                tags: filterTagIdList,
                title: scrapTextField.text ?? "",
                type: 1)
            searchScrap(scrapSearchRequest: scrapSearchRequest)
        }
    }
}

extension MyScrapVC: DismissVCDelegate {
    
    func sendNotification() {
        scrapTextField.text = ""
        filterTagViewModel.filterTagList.values = [Tag(tagId: -1,
                                                       name: "필터",
                                                       color: .sparkyOrange,
                                                       buttonType: .add)]
        self.fetchScraps()
    }
}

extension MyScrapVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch selectedButtonType.value {
        case .horizontal:
            return CGSize(width: view.frame.size.width - 40, height: 138)
        case .largeImage:
            return CGSize(width: view.frame.size.width - 40, height: 290)
        }
    }
}

