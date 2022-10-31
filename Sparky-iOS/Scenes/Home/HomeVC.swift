//
//  HomeViewController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa

enum OtherScrapSectionType: Int {
    case first, second, third
}

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    
    private let scrapTextField = SparkyTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 24)).then {
        
        $0.placeholder = "찾고싶은 스크랩의 키워드를 입력해주세요"
        $0.setupLeftImageView(image: UIImage(named: "search")!.withRenderingMode(.alwaysTemplate))
    }
    
    private let homeScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let myScrapTitleLabel = UILabel().then({
        $0.text = "내 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    private let myScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: 244, height: 228)
        flowlayout.minimumInteritemSpacing = 12
        flowlayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.backgroundColor = .background
        cv.layer.cornerRadius = 8
        cv.showsHorizontalScrollIndicator = false
        cv.register(ScrapCollectionViewCell.self,
                    forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    private let otherScrapTitleLabel = UILabel().then({
        $0.text = "다른 사람 스크랩"
        $0.font = .subTitleBold1
        $0.textAlignment = .center
        $0.textColor = .sparkyBlack
    })
    
    private let otherScrapSubTitleLabel = UILabel().then({
        $0.text = "타 이용자가 저장한 콘텐츠를 추천해줍니다"
        $0.font = .bodyRegular1
        $0.textAlignment = .center
        $0.textColor = .gray600
    })
    
    private let otherScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        //        flowlayout.itemSize = CGSize(width: 244, height: 228)
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.backgroundColor = .background
        cv.layer.cornerRadius = 8
        cv.showsHorizontalScrollIndicator = false
        cv.register(ScrapCollectionViewCell.self,
                    forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
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
        bindViewModel()
    }
    
    //    override func prepare() {
    //        super.prepare()
    //
    //        guard let collectionView = collectionView else { return }
    //
    //        // Reset cached information.
    //        cachedAttributes.removeAll()
    //        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
    //
    //        // For every item in the collection view:
    //        //  - Prepare the attributes.
    //        //  - Store attributes in the cachedAttributes array.
    //        //  - Combine contentBounds with attributes.frame.
    //        let count = collectionView.numberOfItems(inSection: 0)
    //
    //        var currentIndex = 0
    //        var segment: MosaicSegmentStyle = .fullWidth
    //        var lastFrame: CGRect = .zero
    //
    //        let cvWidth = collectionView.bounds.size.width
    //
    //        while currentIndex < count {
    //            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: 200.0)
    //
    //            var segmentRects = [CGRect]()
    //            switch segment {
    //            case .fullWidth:
    //                segmentRects = [segmentFrame]
    //
    //            case .fiftyFifty:
    //                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
    //                segmentRects = [horizontalSlices.first, horizontalSlices.second]
    //
    //            case .twoThirdsOneThird:
    //                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (2.0 / 3.0), from: .minXEdge)
    //                let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
    //                segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]
    //
    //            case .oneThirdTwoThirds:
    //                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (1.0 / 3.0), from: .minXEdge)
    //                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
    //                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
    //            }
    //
    //            // Create and cache layout attributes for calculated frames.
    //            for rect in segmentRects {
    //                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
    //                attributes.frame = rect
    //
    //                cachedAttributes.append(attributes)
    //                contentBounds = contentBounds.union(lastFrame)
    //
    //                currentIndex += 1
    //                lastFrame = rect
    //            }
    //
    //            // Determine the next segment style.
    //            switch count - currentIndex {
    //            case 1:
    //                segment = .fullWidth
    //            case 2:
    //                segment = .fiftyFifty
    //            default:
    //                switch segment {
    //                case .fullWidth:
    //                    segment = .fiftyFifty
    //                case .fiftyFifty:
    //                    segment = .twoThirdsOneThird
    //                case .twoThirdsOneThird:
    //                    segment = .oneThirdTwoThirds
    //                case .oneThirdTwoThirds:
    //                    segment = .fiftyFifty
    //                }
    //            }
    //        }
    //    }
    
    private func setupNavBar() {
        let logoButtonItem = UIBarButtonItem(image: UIImage(named: "logo")!.withRenderingMode(.alwaysOriginal),
                                             style: .done,
                                             target: self,
                                             action: nil)
        
        let profileButtonItem = UIBarButtonItem(image: UIImage(named: "profile")!.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: nil)
        profileButtonItem.rx.tap
            .subscribe { _ in
                self.navigationController?.pushViewController(MyScrapVC(), animated: true)
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = logoButtonItem
        navigationItem.rightBarButtonItem = profileButtonItem
    }
    
    private func setupConstraints() {
        view.addSubview(scrapTextField)
        scrapTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalTo(view).offset(20)
            $0.right.equalTo(view).offset(-20)
        }
        
        view.addSubview(homeScrollView)
        homeScrollView.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom)
            $0.left.equalTo(view)
            $0.bottom.equalTo(view)
            $0.right.equalTo(view)
        }
        
        homeScrollView.addSubview(myScrapTitleLabel)
        myScrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapTextField.snp.bottom).offset(18)
            $0.left.equalTo(view).offset(20)
        }
        
        homeScrollView.addSubview(myScrapCollectionView)
        myScrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(myScrapTitleLabel.snp.bottom).offset(12)
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(228)
        }
    }
    
    private func bindViewModel() {
        viewModel.scraps.value.myScraps.bind(to: myScrapCollectionView.rx.items(
            cellIdentifier: ScrapCollectionViewCell.identifier,
            cellType: ScrapCollectionViewCell.self)) { index, scrap, cell in
                cell.backgroundColor = .white
                cell.setupConstraints()
                cell.setupValue(scrap: scrap)
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                scrap.tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
}

extension HomeVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let share = viewModel.scraps.value.myScraps.values.count / 5
        let remainder = viewModel.scraps.value.myScraps.values.count % 5
        var numOfSection = 0
        
        if remainder == 1 || remainder == 2 {
            numOfSection = 3 * share + 1
        } else if remainder == 3 || remainder == 4 {
            numOfSection = 3 * share + 2
        } else {
            numOfSection = 3 * share
        }
        return numOfSection
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
    
    
}
