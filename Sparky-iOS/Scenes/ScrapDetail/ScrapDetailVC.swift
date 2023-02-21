//
//  ScrapDetailVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/03.
//

import UIKit
import RxSwift
import RxRelay

final class ScrapDetailVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var scrap = BehaviorRelay<Scrap>(value: Scrap(scrapId: 0,
                                                  title: "",
                                                  subTitle: "",
                                                  memo: "",
                                                  thumbnailURLString: "",
                                                  scrapURLString: "",
                                                  tagList: BehaviorRelay(value: [])))
    weak var dismissVCDelegate: DismissVCDelegate?
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    private let scrapBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let scrapView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = false
    }
    
    private var thumbnailImageView = UIImageView().then {
        $0.image = .vector1
        $0.backgroundColor = UIColor.gray200
        $0.contentMode = .center
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private var scrapTextView = DynamicHeightTextView().then {
        $0.font = .bodyBold2
        $0.textAlignment = .left
        $0.textColor = .black
        $0.contentInset = UIEdgeInsets(top: -8,
                                       left: -5,
                                       bottom: 0,
                                       right: 0)
        $0.textContainer.maximumNumberOfLines = 2
        $0.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    private var scrapSubTextView = DynamicHeightTextView().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.contentInset = UIEdgeInsets(top: -8,
                                       left: -5,
                                       bottom: 0,
                                       right: 0)
        $0.textContainer.maximumNumberOfLines = 2
        $0.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let tagTitleLabel = UILabel().then {
        $0.text = "추가할 태그"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let tagCollectionView = TagCollectionView(frame: CGRect(x: 0,
                                                                    y: 0,
                                                                    width: 100,
                                                                    height: 100),
                                                      collectionViewLayout: TagCollectionViewFlowLayout()).then {
        $0.backgroundColor = .background
    }
    
    private let memoTitleLabel = UILabel().then {
        $0.text = "메모"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let memoTextViewPlaceHolder = "메모를 입력하세요"
    private lazy var memoTextView: UITextView = {
        let tv = UITextView()
        tv.text = memoTextViewPlaceHolder
        tv.font = .bodyRegular1
        tv.textColor = .gray400
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray300.cgColor
        tv.layer.cornerRadius = 8
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.delegate = self
        return tv
    }()
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    private let subActionTableView = UITableView().then {
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
        $0.register(SubActionTableViewCell.self,
                    forCellReuseIdentifier: SubActionTableViewCell.identifier)
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
        $0.isHidden = true
    }
    
    private let keyboardBoxView = UIView()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        
        createObserver()
        subActionTableView.tableFooterView = UIView()
        setupNavBar()
        setupConstraints()
        setupDelegate()
        bindViewModel()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
        // 스크롤 뷰 컨텐츠 사이즈를 subview의 가장 큰 Y값에 맞추기
        let maxY = contentView.subviews.map { $0.frame.maxY }.max() ?? 0
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: maxY)
        
        // 디폴트 텍스트 크기에 맞게 동적으로 높이 설정
        scrapTextView.sizeToTextLength()
        scrapSubTextView.sizeToTextLength()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardBoxView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = keyboardSize.height - UIApplication.safeAreaInsetsBottom
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboardBoxView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = 0
            }
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .gray100
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navBarBackButton = UIBarButtonItem(image: .back,
                                               style: .plain,
                                               target: self,
                                               action: nil)
        navBarBackButton.rx.tap.subscribe { _ in
            self.dismiss(animated: false)
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
        
        let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        editButton.setTitle("수정하기", for: .normal)
        editButton.setTitleColor(.sparkyBlue, for: .normal)
        editButton.addTarget(self,
                             action: #selector(didTapEditButton),
                             for: .touchUpInside)
        let navBarEditButton = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = navBarEditButton
    }
    
    private func setupConstraints() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.left.equalTo(scrollView)
            $0.right.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }
        
        
        self.contentView.addSubview(scrapBackgroundView)
        scrapBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.height.equalTo(122)
        }
        
        self.scrapBackgroundView.addSubview(scrapView)
        scrapView.snp.makeConstraints {
            $0.top.equalTo(scrapBackgroundView).offset(12)
            $0.left.equalTo(scrapBackgroundView).offset(20)
            $0.right.equalTo(scrapBackgroundView).offset(-20)
            $0.height.equalTo(94)
        }
        
        self.scrapView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(scrapView).offset(12)
            $0.bottom.equalTo(scrapView).offset(-12)
            $0.width.equalTo(100)
        }
        
        self.scrapView.addSubview(scrapTextView)
        scrapTextView.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.scrapView.addSubview(scrapSubTextView)
        scrapSubTextView.snp.makeConstraints {
            $0.top.equalTo(scrapTextView.snp.bottom).offset(8)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.contentView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(scrapBackgroundView.snp.bottom)
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.height.equalTo(6)
        }
        
        self.contentView.addSubview(tagTitleLabel)
        tagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        
        self.contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
        }
        
        self.contentView.addSubview(memoTitleLabel)
        memoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(36)
            $0.left.equalTo(contentView).offset(20)
        }
        
        self.contentView.addSubview(memoTextView)
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(100)
        }
        
        self.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(18)
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.height.equalTo(6)
        }
        
        self.contentView.addSubview(subActionTableView)
        subActionTableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(6)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(159)
        }
        
        //        contentView.addSubview(keyboardBoxView)
        //        keyboardBoxView.snp.makeConstraints {
        //            $0.left.equalTo(contentView).offset(20)
        //            $0.bottom.equalTo(contentView).offset(-20)
        //            $0.right.equalTo(contentView).offset(-20)
        //            $0.height.equalTo(0)
        //        }
        //
        //        contentView.addSubview(saveButton)
        //        saveButton.snp.makeConstraints {
        //            $0.left.equalTo(contentView).offset(20)
        //            $0.bottom.equalTo(keyboardBoxView.snp.top)
        //            $0.right.equalTo(contentView).offset(-20)
        //            $0.height.equalTo(50)
        //        }
    }
    
    private func setupDelegate() {
        subActionTableView.dataSource = self
        subActionTableView.delegate = self
    }
    
    private func bindViewModel() {
        memoTextView.rx.text
            .subscribe { text in
                if text != self.memoTextViewPlaceHolder {
                    let newScrap = Scrap(scrapId: self.scrap.value.scrapId,
                                         title: self.scrap.value.title,
                                         subTitle: self.scrap.value.subTitle,
                                         memo: text ?? "",
                                         thumbnailURLString: self.scrap.value.thumbnailURLString,
                                         scrapURLString: self.scrap.value.scrapURLString,
                                         tagList: self.scrap.value.tagList)
                    self.scrap.accept(newScrap)
                }
            } onError: { error in
                print("텍스트 뷰 에러 - \(error)")
            }.disposed(by: disposeBag)
        
        
        scrap.value.tagList
            .bind(to: tagCollectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                
                //                if self.scrap.value.tagList.value[row].tagId != -1 {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCollectionViewCell.identifier,
                    for: indexPath) as! TagCollectionViewCell
                cell.setupConstraints()
                
                let tag = self.scrap.value.tagList.value[row]
                cell.setupTagButton(tag: tag, actionType: .display)
                return cell
                //                } else {
                //                    let cell = collectionView.dequeueReusableCell(
                //                        withReuseIdentifier: TagDottedLineCell.identifier,
                //                        for: indexPath) as! TagDottedLineCell
                //                    cell.setupConstraints()
                //                    cell.setupTagButton()
                //                    return cell
                //                }
            }.disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe { _ in
                var tagIdList = [Int]()
                for i in 0..<self.scrap.value.tagList.value.count - 1 {
                    tagIdList.append(self.scrap.value.tagList.value[i].tagId)
                }
                
                let scrapRequest = ScrapRequest(title: self.scrap.value.title,
                                                subTitle: self.scrap.value.subTitle,
                                                memo: self.scrap.value.memo,
                                                imgUrl: self.scrap.value.thumbnailURLString,
                                                scpUrl: self.scrap.value.scrapURLString,
                                                tags: tagIdList)
                
                HomeServiceProvider.shared
                    .patchScrap(scrapRequest: scrapRequest, scrapId: self.scrap.value.scrapId)
                    .map(PostResultResponse.self)
                    .subscribe { response in
                        print("code - \(response.code)")
                        print("message - \(response.message)")
                        
                        if response.code == "0000" {
                            self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                            
                            print("스크랩 수정 성공!!")
                            self.dismiss(animated: false)
                            self.dismissVCDelegate?.sendNotification()
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
                                            self.didTapDeleteScrapButton()
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
                        print("수정 실패!! - \(error)")
                    }.disposed(by: self.disposeBag)
            } onError: { error in
                self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                print("요청 실패 - \(error)")
            }.disposed(by: self.disposeBag)
        memoTextView.rx
            .didChange
            .subscribe { [weak self] in
                guard let self = self else { return }
                self.autoReSizingTextViewHeight()
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
    
    func autoReSizingTextViewHeight() {
        let size = CGSize(width: self.memoTextView.frame.width, height: .infinity)
        let estimatedSize = self.memoTextView.sizeThatFits(size)
        self.memoTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                if estimatedSize.height >= 100 {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    private func presentTagBottomSheetVC() {
        let tagBottomSheetVC = HomeTagBottomSheetVC()
        tagBottomSheetVC.newTagCVDelegate = self
        tagBottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(tagBottomSheetVC, animated: false)
    }
    
    private func setupData() {
        scrapTextView.text = scrap.value.title
        scrapSubTextView.text = scrap.value.subTitle
        thumbnailImageView.setImage(with: scrap.value.thumbnailURLString)
        memoTextView.text = scrap.value.memo
        memoTextView.isUserInteractionEnabled = false
    }
    
    func convertToDeleteType(tagList: [Tag]) -> [Tag] {
        var newTagList = tagList
        
        for i in 0..<newTagList.count {
            newTagList[i].buttonType = .delete
        }
        
        let addButtonTag = Tag(tagId: -1,
                               name: "태그추가",
                               color: .clear,
                               buttonType: .add)
        newTagList.append(addButtonTag)
        return newTagList
    }
    
    private func didTapDeleteScrapButton() {
        HomeServiceProvider.shared
            .removeScrap(scrapId: scrap.value.scrapId)
            .map(PostResultResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    
                    print("스크랩 삭제 성공!!")
                    self.dismiss(animated: false)
                    self.dismissVCDelegate?.sendNotification()
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
                                    self.didTapDeleteScrapButton()
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
                print("스크랩 삭제 실패!! - \(error)")
            }.disposed(by: disposeBag)
    }
    
    @objc private func didTapEditButton() {
        navigationItem.rightBarButtonItem?.customView?.isHidden = true
        scrap.value.tagList.values = convertToDeleteType(tagList: scrap.value.tagList.value)
        
        tagCollectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                if self.scrap.value.tagList.value.count > 0 {
                    switch indexPath.row {
                    case self.scrap.value.tagList.value.count - 1:
                        self.presentTagBottomSheetVC()
                        break
                        
                    default:
                        self.scrap.value.tagList.values.remove(at: indexPath.row)
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        if memoTextView.text == nil {
            memoTextView.text = memoTextViewPlaceHolder
            memoTextView.layer.borderWidth = 1
            memoTextView.layer.borderColor = UIColor.gray300.cgColor
            memoTextView.textColor = .gray400
        } else {
            memoTextView.layer.borderWidth = 1
            memoTextView.layer.borderColor = UIColor.sparkyBlack.cgColor
            memoTextView.textColor = .sparkyBlack
        }
        memoTextView.isUserInteractionEnabled = true
        saveButton.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension ScrapDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == memoTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .sparkyBlack
            textView.layer.borderColor = UIColor.sparkyBlack.cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if memoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextViewPlaceHolder
            textView.textColor = .gray400
            textView.layer.borderColor = UIColor.gray300.cgColor
        }
    }
}

extension ScrapDetailVC: NewTagCVDelegate {
    func sendNewTagList(tag: Tag) {
        var newTag = tag
        newTag.buttonType = .delete
        scrap.value.tagList.insert(newTag, at: 0)
    }
}

extension ScrapDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubActionTableViewCell.identifier,
                                                 for: indexPath) as! SubActionTableViewCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.actionLabel.text = "공유하기"
            } else {
                cell.actionLabel.text = "URL 복사하기"
            }
        } else {
            cell.actionLabel.text = "삭제하기"
            cell.actionLabel.textColor = .sparkyOrange
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension ScrapDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                do {
                    print("url string - \(scrap.value.thumbnailURLString)")
                    
                    var thumbnailURLString: URL
                    
                    if let url = URL(string: scrap.value.thumbnailURLString), url.host != nil {
                        thumbnailURLString = URL(string: scrap.value.thumbnailURLString)!
                    } else {
                        thumbnailURLString = URL(string: Strings.sparkyImageString)!
                    }
                    
                    if let image = UIImage(data: try Data(contentsOf: thumbnailURLString)) {
                        let vc = UIActivityViewController(activityItems: [scrap.value.title, image], applicationActivities: [])
                        present(vc, animated: true, completion: nil)
                    }
                } catch {
                    print("error!")
                }
            } else {
                UIPasteboard.general.string = scrap.value.scrapURLString
                self.view.makeToast("URL이 복사되었습니다.", duration: 1.5, position: .bottom)
            }
        } else {
            self.didTapDeleteScrapButton()
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
