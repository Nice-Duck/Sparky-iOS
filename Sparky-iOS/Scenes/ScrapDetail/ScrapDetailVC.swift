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
    
    private let scrapBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let scrapView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 8
    }
    
    private var scrapImageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFit
    }
    
    private var scrapTitleLabel = UILabel().then {
        $0.text = "스으으으으으크크크크크크크크으으으으으으으으래래래래래애애애애애앱~~~~~"
        $0.font = .bodyBold2
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private var scrapSubTitleLabel = UILabel().then {
        $0.text = "스으으으으으크크크크크크크크으으으으으으으으래래래래래애애애애애앱~~~~~"
        $0.font = .bodyRegular1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.numberOfLines = 2
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
        //        $0.separatorColor = $0.backgroundColor
        $0.isScrollEnabled = false
        $0.allowsSelection = false
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
            self.navigationController?.popViewController(animated: true)
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
        editButton.tintColor = .sparkyBlue
        editButton.addTarget(self,
                             action: #selector(didTapEditButton),
                             for: .touchUpInside)
        
        //        let navBarEditButton = UIBarButtonItem(customView: editButton)
        let navBarEditButton = UIBarButtonItem(title: "수정하기",
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapEditButton))
        navBarEditButton.tintColor = .sparkyBlue
        self.navigationItem.rightBarButtonItem = navBarEditButton
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
        
        self.scrapView.addSubview(scrapImageView)
        scrapImageView.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(scrapView).offset(12)
            $0.bottom.equalTo(scrapView).offset(-12)
            $0.width.equalTo(100)
        }
        
        self.scrapView.addSubview(scrapTitleLabel)
        scrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(scrapImageView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.scrapView.addSubview(scrapSubTitleLabel)
        scrapSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(scrapImageView.snp.right).offset(12)
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
                cell.setupTagButton(tag: tag)
            }.disposed(by: disposeBag)
    }
    
    private func presentTagBottomSheetVC() {
        let tagBottomSheetVC = TagBottomSheetVC()
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
        scrapImageView.setupImageView(frameSize: CGSize(width: 100, height: 70), url: URL(string: scrap.value.thumbnailURLString))
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
        
        let addButtonTag = Tag(name: "태그추가",
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

extension ScrapDetailVC: UITableViewDataSource, UITableViewDelegate {
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.actionLabel.text = "공유하기"
            } else {
                cell.actionLabel.text = "URL 복사하기"
            }
        } else {
            cell.actionLabel.text = "삭제하기"
            cell.actionLabel.textColor = .sparkyOrange
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}
