//
//  CustomShareVC.swift
//  Sparky
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import RxSwift
import RxCocoa
import SnapKit
import Then
import SwiftLinkPreview
import Kingfisher
import Lottie
import Toast_Swift

final class CustomShareVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = AddTagViewModel()
    private let previewViewModel = PreviewViewModel()
    
    var urlString: String? = nil
    
    private let customActivityIndicatorView = CustomActivityIndicatorView().then {
        $0.loadingView.color = .white
        $0.backgroundColor = .gray700.withAlphaComponent(0.8)
        $0.isHidden = true
    }
    
    private let scrapBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let scrapView = UIView().then {
        $0.backgroundColor = .sparkyWhite
        $0.layer.cornerRadius = 8
    }
    
    private let thumbnailBackgoundView = UIView().then {
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
    
    private let addTagCollectionView = TagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                                         collectionViewLayout: TagCollectionViewFlowLayout()).then({
        $0.backgroundColor = .background
    })
    
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
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.sparkyWhite, for: .normal)
        $0.titleLabel?.font = .bodyBold2
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .sparkyBlack
    }
    
    private let keyboardBoxView = UIView()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background
        
        createObserver()
        setupNavBar()
        setupConstraints()
        setupLoadingView()
        bindViewModel()
        setupScrap()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                    constraint.constant = keyboardSize.height - view.safeAreaInsets.bottom
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
        
        let ncBarTitleLabel = UILabel().then {
            $0.text = "스크랩 저장"
            $0.font = .subTitleBold1
            $0.textAlignment = .center
            $0.textColor = .sparkyBlack
        }
        
        let ncBarCancelButton = UIBarButtonItem(image: UIImage(named: "clear"),
                                                style: .plain,
                                                target: self,
                                                action: nil)
        ncBarCancelButton.rx.tap.subscribe { _ in
            let error = NSError(domain: "sparky.bundle.identifier",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "An error description"])
            self.extensionContext?.cancelRequest(withError: error)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        self.navigationItem.titleView = ncBarTitleLabel
        self.navigationItem.leftBarButtonItem = ncBarCancelButton
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
        
        self.scrapView.addSubview(thumbnailBackgoundView)
        thumbnailBackgoundView.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(scrapView).offset(12)
            $0.bottom.equalTo(scrapView).offset(-12)
            $0.width.equalTo(100)
        }
        
        thumbnailBackgoundView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalTo(thumbnailBackgoundView)
            $0.centerY.equalTo(thumbnailBackgoundView)
        }
        
        self.scrapView.addSubview(scrapTitleLabel)
        scrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapView).offset(12)
            $0.left.equalTo(thumbnailBackgoundView.snp.right).offset(12)
            $0.right.equalTo(scrapView).offset(-12)
        }
        
        self.scrapView.addSubview(scrapSubTitleLabel)
        scrapSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(thumbnailBackgoundView.snp.right).offset(12)
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
        
        self.view.addSubview(addTagCollectionView)
        addTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        self.view.addSubview(memoTitleLabel)
        memoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(addTagCollectionView.snp.bottom).offset(36)
            $0.left.equalTo(view).offset(20)
        }
        
        self.view.addSubview(memoTextView)
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(100)
        }
        
        view.addSubview(keyboardBoxView)
        keyboardBoxView.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(20)
            $0.bottom.equalTo(keyboardBoxView.snp.top)
            $0.right.equalTo(view).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    func setupLoadingView() {
        let window = self.navigationController?.navigationBar.window
        window?.addSubview(customActivityIndicatorView)
        customActivityIndicatorView.snp.makeConstraints {
            $0.top.equalTo(window ?? view)
            $0.left.equalTo(window ?? view)
            $0.bottom.equalTo(window ?? view)
            $0.right.equalTo(window ?? view)
        }
    }
    
    private func bindViewModel() {
        viewModel.addTagList
            .bind(to: addTagCollectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                
                if row != self.viewModel.addTagList.value.count - 1 {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagCollectionViewCell.identifier,
                        for: indexPath) as! TagCollectionViewCell
                    cell.setupConstraints()
                    
                    let tag = self.viewModel.addTagList.value[row]
                    cell.setupTagButton(tag: tag, pageType: .main)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagDottedLineCell.identifier,
                        for: indexPath) as! TagDottedLineCell
                    cell.setupConstraints()
                    cell.setupTagButton()
                    return cell
                }
            }.disposed(by: disposeBag)
        
        addTagCollectionView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                if self.viewModel.addTagList.value.count > 0 {
                    switch indexPath.row {
                    case self.viewModel.addTagList.value.count - 1:
                        self.presentTagBottomSheetVC()
                        break
                        
                    default:
                        self.viewModel.addTagList.remove(at: indexPath.row)
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe { _ in
                let preview = self.previewViewModel.preview
                let memo = self.memoTextView.text
                var tagIdList = [Int]()
                
                for i in 0 ..< self.viewModel.addTagList.value.count - 1 {
                    tagIdList.append(self.viewModel.addTagList.value[i].tagId)
                }
                
                let newScrapRequest = ScrapRequest(title: preview?.title ?? "",
                                                   subTitle: preview?.subtitle ?? "",
                                                   memo: memo ?? "",
                                                   imgUrl: preview?.thumbnailURLString ?? "",
                                                   scpUrl: preview?.scrapURLString ?? "",
                                                   tags: tagIdList)
                self.saveMyScrap(scrapRequest: newScrapRequest)
            }.disposed(by: disposeBag)
        
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
    
    private func saveMyScrap(scrapRequest: ScrapRequest) {
        self.customActivityIndicatorView.isHidden = false
        self.customActivityIndicatorView.loadingView.startAnimating()
        ShareServiceProvider.shared
            .saveScrap(scrapRequest: scrapRequest)
            .map(PostResultResponse.self)
            .subscribe { response in
                print("code: \(response.code)")
                print("message: \(response.message)")
                
                if response.code == "0000" {
                    print("---요청 성공!!!---")
                    
                    self.customActivityIndicatorView.loadingView.stopAnimating()
                    self.customActivityIndicatorView.isHidden = true
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    let error = NSError(domain: "sparky.bundle.identifier",
                                        code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "An error description"])
                    self.extensionContext?.cancelRequest(withError: error)
                } else {
                    self.customActivityIndicatorView.loadingView.stopAnimating()
                    self.customActivityIndicatorView.isHidden = true
                    self.view.makeToast(response.message, duration: 1.5, position: .bottom)
                    print("---응답 실패!!!---")
                }
                
            } onFailure: { error in
                self.view.makeToast("네트워크 상태를 확인해주세요.", duration: 1.5, position: .bottom)
                print("---요청 실패---")
                print(error)
            }.disposed(by: disposeBag)
    }
    
    private func presentTagBottomSheetVC() {
        let tagBottomSheetVC = ShareTagBottomSheetVC()
        tagBottomSheetVC.newTagCVDelegate = self
        tagBottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(tagBottomSheetVC, animated: false)
    }
    
    private func setupScrap() {
        if let urlString = urlString {
            setupScrap(urlString: urlString)
        } else {
            if let item = extensionContext?.inputItems.first as? NSExtensionItem {
                print("item is not nil")
                accessWebpageProperites(extentionItem: item)
            }
        }
    }
    
    private func setupScrap(urlString: String) {
        self.previewViewModel.fetchPreview(urlString: urlString) { preview in
            do {
                if let preview = preview {
                    print("CustomShareVC response - \(preview)")
                    if let url = URL(string: preview.thumbnailURLString) {
                        self.thumbnailImageView.snp.makeConstraints {
                            $0.width.equalTo(self.thumbnailBackgoundView)
                            $0.height.equalTo(self.thumbnailBackgoundView)
                        }
                        self.thumbnailImageView.kf.setImage(with: url)
                    }
                    self.scrapTitleLabel.text = preview.title
                    self.scrapSubTitleLabel.text = preview.subtitle
                }
            } catch {
                print("스크랩 정보 불러오기 실패!")
            }
        }
    }
    
    private func accessWebpageProperites(extentionItem: NSExtensionItem) {
        if let attachments = extentionItem.attachments {
            for attachment: NSItemProvider in attachments {
                if attachment.hasItemConformingToTypeIdentifier("public.url") {
                    attachment.loadItem(forTypeIdentifier: "public.url",
                                        options: nil) { (url, error) in
                        
                        print("Web Page URL - \(url)")
                        
                        if let url = url as? URL {
                            let urlString = url.absoluteString
                            self.setupScrap(urlString: urlString)
                        }
                        
                        // 크롤링 코드
                        //                        if let url = url as? URL {
                        //                            DispatchQueue.main.async {
                        //                                CrwalManager().getTistoryScrap(url: url) { scrap in
                        //                                    self.scrapImageView.image = UIImage(data: try! Data(contentsOf: scrap.thumbnailURL))
                        //                                    self.scrapTitleLabel.text = scrap.title
                        //                                    self.scrapSubTitleLabel.text = scrap.subTitle
                        //                                }
                        //                            }
                        //                        }
                    }
                }
            }
        }
    }
}

extension CustomShareVC: UITextViewDelegate {
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

extension CustomShareVC: NewTagCVDelegate {
    func sendNewTagList(tag: Tag) {
        let newTag = Tag(tagId: tag.tagId,
                         name: tag.name,
                         color: tag.color,
                         buttonType: .delete)
        
        if !viewModel.addTagList.value.contains(where: { tag in
            if tag == newTag {
                return true
            }
            return false
        }) {
            viewModel.addTagList.insert(newTag, at: 0)
        }
    }
}
