//
//  MyScrapPreViewCollectionViewCell.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/01.
//

import UIKit
import RxSwift
import SwiftSoup

final class MyScrapPreViewCollectionViewCell: UITableViewCell {
    
    static let identifier = "MyScrapPreViewCollectionViewCell"
    
    var viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    
    let myScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: 244, height: 228)
        flowlayout.minimumInteritemSpacing = 12
        flowlayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.backgroundColor = .background
        cv.layer.cornerRadius = 8
        cv.showsHorizontalScrollIndicator = false
        cv.register(PreviewLayoutViewCell.self,
                    forCellWithReuseIdentifier: PreviewLayoutViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        createObserver()
//        bindViewModel()
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
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrapDetail),
                                               name: SparkyNotification.sendScrapDetailIndex,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrapWebView),
                                               name: SparkyNotification.sendScrapWebViewIndex,
                                               object: nil)
    }
    
    @objc private func showScrapDetail(notification: NSNotification) {
        if let index = notification.object {
            let scrap = viewModel.scraps.value[index as! Int]
            NotificationCenter.default.post(name: SparkyNotification.showScrapDetail, object: scrap)
        }
    }
    
    @objc private func showScrapWebView(notification: NSNotification) {
        if let index = notification.object {
            let scrap = viewModel.scraps.value[index as! Int]
            NotificationCenter.default.post(name: SparkyNotification.showScrapWebView, object: scrap)
        }
    }
    
    func bindViewModel() {
//        myScrapCollectionView.dataSource = nil
        
        viewModel.scraps.bind(to: myScrapCollectionView.rx.items(
            cellIdentifier: PreviewLayoutViewCell.identifier,
            cellType: PreviewLayoutViewCell.self)) { index, scrap, cell in
                cell.backgroundColor = .sparkyWhite
                cell.setupValue(scrap: scrap)
                cell.scrapDetailButton.tag = index
                cell.thumbnailImageView.tag = index
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                print("taglist - \(scrap.tagList.value)")
                scrap.tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
}
