//
//  MyScrapCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit
import RxSwift

final class MyScrapCollectionViewCell: UITableViewCell {
    
    static let identifier = "MyScrapCollectionViewCell"
    
    private let viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(myScrapCollectionView)
        myScrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.equalTo(contentView)
            $0.bottom.equalTo(contentView)
            $0.right.equalTo(contentView)
        }
    }
    
    private func bindViewModel() {
        viewModel.scraps.value.myScraps.bind(to: myScrapCollectionView.rx.items(
            cellIdentifier: ScrapCollectionViewCell.identifier,
            cellType: ScrapCollectionViewCell.self)) { index, scrap, cell in
                cell.backgroundColor = .white
                cell.setupMyScrapLayoutConstraints()
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
