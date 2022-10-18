//
//  TagBottomSheetVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/16.
//

import UIKit
import RxSwift
import RxCocoa

final class TagBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel = RecentTagViewModel()
    
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
    
    private let tagSearchBar = UISearchBar().then {
        $0.placeholder = "검색할 태그를 입력해주세요(최대 7글자)"
        $0.showsCancelButton = false
        $0.isTranslucent = false
        $0.searchBarStyle = .minimal
        $0.setBackgroundImage(UIImage(), for: .bottom, barMetrics: .default)
        
        for view in $0.searchTextField.subviews {
            view.backgroundColor = .sparkyWhite
        }
        
    }
    
    private let recentTagTitleLabel = UILabel().then {
        $0.text = "최근 사용한 태그"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    }
    
    private let recentTagCollectionView = TagCollectionView(frame: CGRect(x: 0,
                                                                          y: 0,
                                                                          width: 100,
                                                                          height: 100),
                                                            collectionViewLayout: TagCollectionViewFlowLayout())
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavBar()
        setupConstraintes()
        bindViewModel()
        setupCollectionViewDelegate()
        setupDimmendTabGesture()
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
        customNavBar.layoutIfNeeded()
    }
    
    private func setupConstraintes() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        tagBottomSheetView.addSubview(tagSearchBar)
        tagSearchBar.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(11)
            $0.left.equalTo(tagBottomSheetView).offset(4)
            $0.right.equalTo(tagBottomSheetView).offset(-4)
            $0.height.equalTo(44)
        }
        
        tagBottomSheetView.addSubview(recentTagTitleLabel)
        recentTagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagSearchBar.snp.bottom).offset(16)
            $0.left.equalTo(tagBottomSheetView).offset(20)
        }
        
        tagBottomSheetView.addSubview(recentTagCollectionView)
        recentTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentTagTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(tagBottomSheetView).offset(20)
            $0.right.equalTo(tagBottomSheetView).offset(-20)
        }
    }
    
    private func bindViewModel() {
        viewModel.filterTagList = viewModel.recentTagList
        
        tagSearchBar.searchTextField.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                print("text - \(text.description)")
                self.viewModel.filterTagList = self.viewModel.recentTagList.filter {  $0.text.hasPrefix(text)
                }
                self.recentTagCollectionView.reloadData()
            }).disposed(by: disposeBag)

    }
    
    private func setupCollectionViewDelegate() {
        recentTagCollectionView.dataSource = self
        recentTagCollectionView.delegate = self
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
}

extension TagBottomSheetVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath) as! TagCollectionViewCell
        cell.setupConstraints()
        cell.setupTagButton(tag: viewModel.filterTagList[indexPath.row])
        return cell
    }
}
