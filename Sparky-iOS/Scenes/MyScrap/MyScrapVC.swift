//
//  MyScrapVC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import UIKit
import RxSwift

enum setViewButtonType {
    case horizontal, largeImage
}

final class MyScrapVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    private var selectedButtonType = setViewButtonType.horizontal
    
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
        cv.register(ScrapCollectionViewCell.self,
                    forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
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
        setupData()
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
        viewModel.scraps.value.myScraps.bind(to: myScrapCollectionView.rx.items(
            cellIdentifier: ScrapCollectionViewCell.identifier,
            cellType: ScrapCollectionViewCell.self)) { index, scrap, cell in
                cell.backgroundColor = .white
                cell.setupValue(scrap: scrap)
                
                print("rx 호출!!")
                
//                self.myScrapCollectionView.dataSource = nil
//                self.myScrapCollectionView.delegate = nil
//                cell.thumbnailImageView.layoutIfNeeded()
                
                switch self.selectedButtonType {
                case .horizontal:
                    cell.setupHorizontalLayoutConstraints()
                    
                case .largeImage:
                    cell.setupLargeImageConstraints()
                }
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                scrap.tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag)
                    }.disposed(by: self.disposeBag)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }.disposed(by: disposeBag)
        
//        myScrapSectionView.setHorizontalViewButton.rx.tap
//            .map({
//            })
//            .bind(to: myScrapSectionView.setHorizontalViewButton.tintColor)
//            }.disposed(by: disposeBag)
        
        myScrapSectionView.setHorizontalViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setHorizontalViewButton.tintColor = self.myScrapSectionView.setHorizontalViewButton.isSelected ? .gray400 : .sparkyBlack
                self.myScrapSectionView.setLargeImageViewButton.tintColor = self.myScrapSectionView.setHorizontalViewButton.isSelected ? .sparkyBlack : .gray400
                self.selectedButtonType = setViewButtonType.horizontal
//                self.myScrapCollectionView.updateConstraints()
//                self.myScrapCollectionView.delegate = self
                self.myScrapCollectionView.reloadData()
            }.disposed(by: disposeBag)
//
        myScrapSectionView.setLargeImageViewButton.rx.tap
            .subscribe { _ in
                self.myScrapSectionView.setLargeImageViewButton.tintColor = self.myScrapSectionView.setLargeImageViewButton.isSelected ? .gray400 : .sparkyBlack
                self.myScrapSectionView.setHorizontalViewButton.tintColor = self.myScrapSectionView.setLargeImageViewButton.isSelected ? .sparkyBlack : .gray400
                self.selectedButtonType = setViewButtonType.largeImage
//                self.myScrapCollectionView.updateConstraints()
//                self.myScrapCollectionView.delegate = self
                self.myScrapCollectionView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    private func setupData() {
        myScrapSectionView.totalCountLabel.text = "총 \(viewModel.scraps.value.myScraps.values.count)개"
    }
    
//    @objc private didTap
}

extension MyScrapVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("delegate 호출!!")
        switch selectedButtonType {
        case .horizontal:
            return CGSize(width: view.frame.size.width - 40, height: 138)
        case .largeImage:
            return CGSize(width: view.frame.size.width - 40, height: 290)
        }
    }
}

