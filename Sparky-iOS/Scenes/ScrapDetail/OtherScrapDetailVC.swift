//
//  OtherScrapDetailVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/09.
//

import UIKit
import RxSwift
import RxRelay

final class OtherScrapDetailVC: UIViewController {
    
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
    
    private let scrapBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let scrapView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 8
    }
    
    private let thumbnailBackgourndView = UIView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 4
    }
    
    private var thumbnailImageView = UIImageView().then {
        $0.image = .vector1
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private var scrapTitleLabel = CustomVAlignLabel().then {
        $0.font = .bodyBold2
        $0.textAlignment = .left
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.verticalAlignment = .top
    }
    
    private var scrapSubTitleLabel = CustomVAlignLabel().then {
        $0.font = .bodyRegular1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.verticalAlignment = .top
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
    
    private let tagCollectionView = TagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
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
    private lazy var memoTextView = UITextView().then {
        $0.text = memoTextViewPlaceHolder
        $0.font = .bodyRegular1
        $0.textColor = .sparkyBlack
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        $0.layer.cornerRadius = 8
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
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
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background
        subActionTableView.tableFooterView = UIView()
        setupNavBar()
        setupConstraints()
        setupDelegate()
        bindViewModel()
        setupData()
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .gray100
        self.navigationController?.navigationBar.tintColor = .black
        
        let navBarBackButton = UIBarButtonItem(image: UIImage(named: "back"),
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
    }
    
    private func setupConstraints() {
        self.view.addSubview(scrapBackgroundView)
        scrapBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(122)
        }
        
        self.scrapBackgroundView.addSubview(scrapView)
        scrapView.snp.makeConstraints {
            $0.top.equalTo(scrapBackgroundView).offset(12)
            $0.left.equalTo(scrapBackgroundView).offset(20)
            $0.right.equalTo(scrapBackgroundView).offset(-20)
            $0.height.equalTo(94)
        }
        
        self.scrapView.addSubview(thumbnailBackgourndView)
        thumbnailBackgourndView.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(scrapView).offset(12)
            $0.bottom.equalTo(scrapView).offset(-12)
            $0.width.equalTo(100)
        }
        
        self.thumbnailBackgourndView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalTo(thumbnailBackgourndView)
            $0.centerY.equalTo(thumbnailBackgourndView)
        }
        
        self.scrapView.addSubview(scrapTitleLabel)
        scrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(thumbnailBackgourndView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.scrapView.addSubview(scrapSubTitleLabel)
        scrapSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(thumbnailBackgourndView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.view.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(scrapBackgroundView.snp.bottom)
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(6)
        }
        
        self.view.addSubview(tagTitleLabel)
        tagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.left.equalTo(view).offset(20)
        }
        
        self.view.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        self.view.addSubview(memoTitleLabel)
        memoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(36)
            $0.left.equalTo(view).offset(20)
        }
        
        self.view.addSubview(memoTextView)
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(100)
        }
        
        self.view.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(18)
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(6)
        }
        
        self.view.addSubview(subActionTableView)
        subActionTableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(6)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(200)
        }
        
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    private func setupDelegate() {
        subActionTableView.dataSource = self
        subActionTableView.delegate = self
    }
    
    private func bindViewModel() {
        scrap.value.tagList
            .bind(to: tagCollectionView.rx.items(cellIdentifier: TagCollectionViewCell.identifier, cellType: TagCollectionViewCell.self)) { index, tag, cell in
                cell.setupConstraints()
                cell.setupTagButton(tag: tag, pageType: .main)
            }.disposed(by: disposeBag)
    }
    
    private func presentTagBottomSheetVC() {
        let tagBottomSheetVC = HomeTagBottomSheetVC()
        tagBottomSheetVC.newTagCVDelegate = self
        tagBottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(tagBottomSheetVC, animated: false)
    }
    
    //    func convertToNoneType(tagList: [Tag]) -> [Tag] {
    //        if tagList.isEmpty {
    //            return []
    //        }
    //
    //        var newTagList = tagList
    //        if newTagList[newTagList.count - 1].buttonType == .add { newTagList.removeLast() }
    //
    //        for i in 0..<newTagList.count {
    //            newTagList[i] = Tag(text: newTagList[i].text,
    //                                backgroundColor: newTagList[i].backgroundColor,
    //                                buttonType: .none)
    //        }
    //        return newTagList
    //    }
    
    
    private func setupData() {
        if let url = URL(string: scrap.value.thumbnailURLString) {
            thumbnailImageView.snp.makeConstraints {
                $0.width.equalTo(thumbnailBackgourndView)
                $0.height.equalTo(thumbnailBackgourndView)
            }
            thumbnailImageView.kf.setImage(with: url)
        }
        scrapTitleLabel.text = scrap.value.title
        scrapSubTitleLabel.text = scrap.value.subTitle
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
    
    @objc private func didTapEditButton() {
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
        } else {
            memoTextView.layer.borderWidth = 1
            memoTextView.layer.borderColor = UIColor.sparkyBlack.cgColor
        }
        memoTextView.isUserInteractionEnabled = true
        saveButton.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func claimUser() {
        print("dec scrapId - \(self.scrap.value.scrapId)")
        HomeServiceProvider.shared
            .declaration(scrapId: scrap.value.scrapId)
            .map(PostResultResponse.self)
            .subscribe { response in
                print("code - \(response.code)")
                print("message - \(response.message)")
                
                if response.code == "0000" {
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    
                    print("신고 성공!!")
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
                                    self.claimUser()
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
                print("신고 실패!! - \(error)")
            }.disposed(by: disposeBag)
    }
}

extension OtherScrapDetailVC: UITextViewDelegate {
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

extension OtherScrapDetailVC: NewTagCVDelegate {
    func sendNewTagList(tag: Tag) {
        var newTag = tag
        newTag.buttonType = .delete
        scrap.value.tagList.insert(newTag, at: 0)
    }
}

extension OtherScrapDetailVC: CustomPopUpDelegate {
    func action() {
        claimUser()
    }
    
    func exit() { }
}

extension OtherScrapDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubActionTableViewCell.identifier,
            for: indexPath) as! SubActionTableViewCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.actionLabel.text = "내 스크랩에 추가하기"
            } else if indexPath.row == 1 {
                cell.actionLabel.text = "공유하기"
            } else {
                cell.actionLabel.text = "URL 복사하기"
            }
        } else {
            cell.actionLabel.text = "신고하기"
            cell.actionLabel.textColor = .sparkyOrange
            cell.selectionStyle = .none
        }
        return cell
    }
}

extension OtherScrapDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let homeCustomShareVC = HomeCustomShareVC()
                homeCustomShareVC.urlString = scrap.value.scrapURLString
                let nav = UINavigationController(rootViewController: homeCustomShareVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else if indexPath.row == 1 {
                do {
                    if let image = UIImage(data: try Data(contentsOf: URL(string: scrap.value.thumbnailURLString) ?? URL(string: Strings.sparkyImageString)!)) {
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
            let customPopUpVC = CustomPopUpVC()
            customPopUpVC.setupValue(title: "신고 하시겠습니까?",
                                     cancelText: "취소하기",
                                     confirmText: "신고하기")
            customPopUpVC.modalPresentationStyle = .overFullScreen
            customPopUpVC.customPopUpDelegate = self
            present(customPopUpVC, animated: false)
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
