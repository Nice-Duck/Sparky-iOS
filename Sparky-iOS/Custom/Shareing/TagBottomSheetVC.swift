//
//  TagBottomSheetVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol NewTagCVDelegate: AnyObject {
    func sendNewTagList(tag: Tag)
}

final class TagBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel = RecentTagViewModel()
    weak var newTagCVDelegate: NewTagCVDelegate?
    
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
    private let defaultTagBottomSheetHeight: CGFloat = 500
    
    private let customNavBar = SparkyNavBar().then {
        $0.backgroundColor = .white
        $0.tintColor = .sparkyBlack
        $0.isTranslucent = false
        $0.shadowImage = UIImage()
    }
    private let customNavItem = UINavigationItem()
    
    private let navTitleLabel = UILabel().then {
        $0.text = "태그 추가"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let navCancelButtonItem = UIBarButtonItem().then {
        $0.image = UIImage(named: "back")
        $0.style = .plain
    }
    
    private let tagTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {
        $0.placeholder = "검색할 태그를 입력해주세요(최대 7글자)"
        $0.setupLeftImageView(image: UIImage(named: "search")!.withRenderingMode(.alwaysTemplate))
        $0.tintColor = .gray400
    }
    
    private let tagContainerView = UIView()
    
    private let recentTagTitleLabel = UILabel().then {
        $0.text = "최근 사용한 태그"
        $0.font = .subTitleBold1
        $0.textColor = .sparkyBlack
    }
    
    private let recentTagCollectionView = TagCollectionView(frame: CGRect(x: 0,
                                                                          y: 0,
                                                                          width: 100,
                                                                          height: 100),
                                                            collectionViewLayout: TagCollectionViewFlowLayout())
    
    private let noDataContainerView = UIView()
    
    private let noDataLabel = UILabel().then {
        $0.text = "검색결과가 없어요"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let newTagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .sparkyBlack
        $0.layer.cornerRadius = 8
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let newTagLabel = CustomPaddingLabel().then {
        $0.font = .badgeBold
        $0.textAlignment = .center
        $0.textColor = .gray700
        $0.backgroundColor = .colorchip3
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let newTagButtonLabel = UILabel().then {
        $0.text = "새 태그 생성하기"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyWhite
    }
    
    private let colorDescriptionLabel = UILabel().then {
        $0.text = "태그 컬러는 마이페이지>태그 목록에서 변경할 수 있어요"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
        $0.backgroundColor = .sparkyWhite
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setupNavBar()
        setupConstraints()
        //        bindViewModel()
        //        setupDelegate()
        setupDimmendTabGesture()
        setupNewTagTapGuesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRecentTagList()
        bindViewModel()
    }
    
    private func fetchRecentTagList() {
        ShareServiceProvider.shared
            .fetchTag()
            .map(RecentTagResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    print("---요청 성공!!!---")
                    print("tagList - \(response.result)")
                    
                    var newTagList = [Tag]()
                    
                    // TODO: 버튼 칼라 수정 해야됨
                    response.result?.tagResponses.forEach { tagResponse in
                        let newTag = Tag(tagId: tagResponse.tagId,
                                         name: tagResponse.name,
                                         color: .colorchip8,
                                         buttonType: .none)
                        newTagList.append(newTag)
                    }
                    self.viewModel.recentTagList = BehaviorRelay<[Tag]>(value: newTagList)
                    print("tagList - \(self.viewModel.recentTagList.value)")
                    //                    self.setupDelegate()
//                    self.bindViewModel()
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
                                    self.fetchRecentTagList()
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
                    print("error response - \(response)")
                }
            } onFailure: { error in
                print("---요청 실패!!!---")
                print(error)
            }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showTagBottomSheet()
    }
    
    private func setupNavBar() {
        navCancelButtonItem.rx.tap.subscribe { _ in
            self.dismissTagBottomSheetVC()
        }.disposed(by: disposeBag)
        
        customNavItem.titleView = navTitleLabel
        customNavItem.leftBarButtonItem = navCancelButtonItem
        customNavBar.setItems([customNavItem], animated: false)
        //        customNavBar.layoutIfNeeded()
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
        
        tagBottomSheetView.addSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(12)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
        }
        
        view.addSubview(tagContainerView)
        tagContainerView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(16)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(tagBottomSheetView)
        }
        
        tagContainerView.addSubview(recentTagTitleLabel)
        recentTagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagContainerView)
            $0.left.equalTo(tagContainerView)
            $0.right.equalTo(tagContainerView)
        }
        
        tagContainerView.addSubview(recentTagCollectionView)
        recentTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentTagTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(tagContainerView)
            $0.right.equalTo(tagContainerView)
        }
        
        view.addSubview(noDataContainerView)
        noDataContainerView.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
            $0.height.equalTo(tagBottomSheetView)
        }
        
        noDataContainerView.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints {
            $0.left.equalTo(noDataContainerView)
            $0.right.equalTo(noDataContainerView)
            $0.height.equalTo(100)
        }
        
        noDataContainerView.addSubview(newTagStackView)
        newTagStackView.snp.makeConstraints {
            $0.top.equalTo(noDataLabel.snp.bottom)
            $0.centerX.equalTo(noDataContainerView)
        }
        
        newTagStackView.addArrangedSubview(newTagLabel)
        newTagStackView.addArrangedSubview(newTagButtonLabel)
        
        noDataContainerView.addSubview(colorDescriptionLabel)
        colorDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(newTagStackView.snp.bottom).offset(16)
            $0.centerX.equalTo(noDataContainerView)
        }
    }
    
    private func bindViewModel() {
//        recentTagCollectionView.dataSource = nil
//        recentTagCollectionView.delegate = nil
        
        viewModel.filterTagList.values = viewModel.recentTagList.value
        print("recentTagList - \(viewModel.filterTagList.values)")
        print("filterList - \(viewModel.filterTagList.values)")
        
        viewModel.filterTagList
            .bind(to: recentTagCollectionView.rx.items(cellIdentifier: TagCollectionViewCell.identifier, cellType: TagCollectionViewCell.self)) { index, tag, cell in
                if tag.buttonType == .add {
                    return
                }
                
                cell.setupConstraints()
                cell.setupTagButton(tag: tag)
            }.disposed(by: disposeBag)
        
        recentTagCollectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.newTagCVDelegate?.sendNewTagList(tag: self.viewModel.filterTagList.value[indexPath.row])
                self.dismissTagBottomSheetVC()
            }).disposed(by: disposeBag)
        
        tagTextField.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                let filteredTagList = self.viewModel.recentTagList.values.filter({
                    $0.name.hasPrefix(text)
                })
                self.viewModel.filterTagList.accept(filteredTagList)
                
                if self.viewModel.filterTagList.value.isEmpty {
                    self.tagContainerView.isHidden = true
                    self.noDataContainerView.isHidden = false
                    self.newTagLabel.text = text
                } else {
                    self.tagContainerView.isHidden = false
                    self.noDataContainerView.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    
    private func showTagBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        tagBottomSheetTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultTagBottomSheetHeight
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
    
    private func setupNewTagTapGuesture() {
        newTagStackView.rx
            .tapGesture()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .when(.recognized)
            .subscribe(onNext: { _ in
                if let text = self.newTagLabel.text, text != "" {
                    let tagRequest = TagRequst(tag: text,
                                               color: "blue")
                    
                    ShareServiceProvider.shared
                        .saveTag(tagRequst: tagRequest)
                        .map(PostResultResponse.self)
                        .subscribe { response in
                            print("code - \(response.code)")
                            print("message - \(response.message)")
                            if response.code == "0000" {
                                print("---요청 성공!!!---")
                                self.fetchRecentTagList()
                            } else {
                                print("---요청 실패!!!---")
                            }
                        } onFailure: { error in
                            print("요청 실패 - \(error)")
                        }.disposed(by: self.disposeBag)
                    
                    
                    
                    self.tagTextField.text = ""
                    self.tagTextField.resignFirstResponder()
                    self.tagTextField.becomeFirstResponder()
                    self.tagContainerView.isHidden = false
                    self.noDataContainerView.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    
    private func moveToSignInVC() {
        guard let nc = self.navigationController else { return }
        var vcs = nc.viewControllers
        vcs = [SignInVC()]
        self.navigationController?.viewControllers = vcs
    }
    
    
    //    func convertToDeleteType(tagList: [Tag]) -> [Tag] {
    //        var newTagList = tagList
    //        for i in 0..<newTagList.count {
    //            newTagList[i] = Tag(tagId: tagList,
    //                                name: <#T##String#>,
    //                                color: <#T##UIColor#>,
    //                                buttonType: <#T##ButtonType#>)
    //            Tag(
    //                text: newTagList[i].text,
    //                                backgroundColor: newTagList[i].backgroundColor,
    //                                buttonType: .delete)
    //        }
    //
    //        let addButtonTag = Tag(text: "태그추가",
    //                               backgroundColor: .clear,
    //                               buttonType: .add)
    //        newTagList.append(addButtonTag)
    //        return newTagList
    //    }
}
