//
//  MyScrapVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import UIKit
import RxSwift
import RxRelay

enum SetViewButtonType {
    case horizontal, largeImage
}

final class MyScrapVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    private var selectedButtonType = BehaviorRelay<SetViewButtonType>(value: SetViewButtonType.horizontal)
    
    private let scrapTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {
        
        $0.placeholder = "검색어를 입력해주세요"
        $0.setupLeftImageView(image: UIImage(named: "search")!.withRenderingMode(.alwaysTemplate))
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
        setupDelegate()
        bindViewModel()
        createObserver()
        
        fetchScraps()
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
                                
                                self.viewModel.scraps.values.append(newScrap)
                            }
                        }
                        print("myScrapViewModel - \(self.viewModel.scraps.value)")
                        print("otherScrapViewModel - \(self.viewModel.scraps.value)")
                        print("reload!!!")
                        self.setupData()
                        self.setupDelegate()
                        self.myScrapCollectionView.reloadData()
                    }
                } else if response.code == "U000" {
                    print("response - \(response)")
                    
                    if let _ = TokenUtils().read("com.sparky.token", account: "accessToken") {
                        TokenUtils().delete("com.sparky.token", account: "accessToken")
                    }
                    
                    HomeServiceProvider.shared
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
        navigationItem.title = "내 스크랩"
    }
    
    private func setupConstraints() {
        view.addSubview(scrapTextField)
        scrapTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        view.addSubview(myScrapSectionView)
        myScrapSectionView.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom).offset(8)
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
    }
    
    private func setupDelegate() {
        myScrapCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        myScrapCollectionView.dataSource = nil
        
        viewModel.scraps.bind(to: myScrapCollectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            switch self.selectedButtonType.value {
            case .horizontal:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyHorizontalLayoutCell.identifier,
                    for: indexPath) as! MyHorizontalLayoutCell
                cell.backgroundColor = .white
                cell.setupValue(scrap: self.viewModel.scraps.value[row])
                
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.viewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag)
                    }.disposed(by: self.disposeBag)
                return cell
                
            case .largeImage:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyLargeImageLayoutCell.identifier,
                    for: indexPath) as! MyLargeImageLayoutCell
                cell.backgroundColor = .white
                cell.setupValue(scrap: self.viewModel.scraps.value[row])
                
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.viewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag)
                    }.disposed(by: self.disposeBag)
                return cell
            }
        }.disposed(by: disposeBag)
        
        myScrapSectionView.setHorizontalViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setHorizontalViewButton.tintColor = .sparkyBlack
                self.myScrapSectionView.setLargeImageViewButton.tintColor = .gray400
                //                self.myScrapCollectionView.performBatchUpdates {
                self.selectedButtonType = BehaviorRelay(value: SetViewButtonType.horizontal)
                self.bindViewModel()
                //                }
            }.disposed(by: disposeBag)
        //
        myScrapSectionView.setLargeImageViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setLargeImageViewButton.tintColor = .sparkyBlack
                self.myScrapSectionView.setHorizontalViewButton.tintColor = .gray400
                //                self.myScrapCollectionView.performBatchUpdates {
                self.selectedButtonType = BehaviorRelay(value: SetViewButtonType.largeImage)
                self.bindViewModel()
                //                }
            }.disposed(by: disposeBag)
    }
    
    private func setupData() {
        myScrapSectionView.totalCountLabel.text = "총 \(viewModel.scraps.value.count)개"
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
    
    @objc private func showScrap(notification: NSNotification) {
        switch notification.name {
        case SparkyNotification.sendMyScrapDetailIndex:
            if let index = notification.object {
                let scrapDetailVC = ScrapDetailVC()
                scrapDetailVC.scrap = BehaviorRelay(value: viewModel.scraps.value[index as! Int])
                navigationController?.pushViewController(scrapDetailVC, animated: false)
            }
            break
        case SparkyNotification.sendMyScrapWebViewIndex:
            if let index = notification.object {
                let scrapWebViewVC = ScrapWebViewVC()
                scrapWebViewVC.modalPresentationStyle = .overFullScreen
                scrapWebViewVC.urlString = viewModel.scraps.value[index as! Int].scrapURLString
                navigationController?.pushViewController(scrapWebViewVC, animated: false)
            }
            break
        default:
            break
        }
    }
    
    private func moveToSignInVC() {
        guard let nc = self.navigationController else { return }
        var vcs = nc.viewControllers
        vcs = [SignInVC()]
        self.navigationController?.viewControllers = vcs
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

