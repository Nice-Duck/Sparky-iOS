//
//  OtherScrapCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit
import RxSwift

final class OtherScrapCollectionViewCell: UITableViewCell {
    
    static let identifier = "OtherScrapCollectionViewCell"
    
    private let viewModel = OtherScrapViewModel()
    private let disposeBag = DisposeBag()
    
    private let otherScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: 244, height: 228)
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .background
        cv.layer.cornerRadius = 8
        cv.showsVerticalScrollIndicator = false
        cv.register(ScrapCollectionViewCell.self,
                    forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupDelegate()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(otherScrapCollectionView)
        otherScrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.equalTo(contentView)
            $0.bottom.equalTo(contentView)
            $0.right.equalTo(contentView)
        }
    }
    
    private func setupDelegate() {
        otherScrapCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.otherScrapList.bind(to: otherScrapCollectionView.rx.items(
            cellIdentifier: ScrapCollectionViewCell.identifier,
            cellType: ScrapCollectionViewCell.self)) { index, scrap, cell in
                let scrapLayoutStyle = ScrapLayoutStyle(rawValue: index) ?? ScrapLayoutStyle.horizontalOne
                switch scrapLayoutStyle {
                case .halfOne, .halfTwo:
                    cell.setupHalfLayoutConstraints()
                case .horizontalOne, .horizontalTwo:
                    cell.setupHorizontalLayoutConstraints()
                case .largeImage:
                    cell.setupLargeImageConstraints()
                }
                
                cell.backgroundColor = .white
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

extension OtherScrapCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scrapLayoutStyle = ScrapLayoutStyle(rawValue: indexPath.row % 5) ?? ScrapLayoutStyle.horizontalOne
        switch scrapLayoutStyle {
        case .halfOne, .halfTwo:
            return CGSize(width: (contentView.frame.size.width - 13 - 40) / 2, height: 241)
        case .horizontalOne, .horizontalTwo:
            return CGSize(width: contentView.frame.size.width - 40, height: 138)
            
        case .largeImage:
            return CGSize(width: contentView.frame.size.width - 40, height: 290)
        }
    }
}
