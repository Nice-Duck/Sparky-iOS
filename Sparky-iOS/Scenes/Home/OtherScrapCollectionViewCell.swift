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
    
    var viewModel = ScrapViewModel()
    private let disposeBag = DisposeBag()
    
    let otherScrapCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: 244, height: 228)
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                  collectionViewLayout: flowlayout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .background
        cv.showsVerticalScrollIndicator = false
        cv.register(HalfLayoutCell.self,
                    forCellWithReuseIdentifier: HalfLayoutCell.identifier)
        cv.register(HorizontalLayoutCell.self,
                    forCellWithReuseIdentifier: HorizontalLayoutCell.identifier)
        cv.register(LargeImageLayoutCell.self,
                    forCellWithReuseIdentifier: LargeImageLayoutCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupDelegate()
        createObserver()
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
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrap),
                                               name: SparkyNotification.sendOtherScrapDetailIndex,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScrap),
                                               name: SparkyNotification.sendOtherWebViewIndex,
                                               object: nil)
    }
    
    @objc private func showScrap(notification: NSNotification) {
        switch notification.name {
        case SparkyNotification.sendOtherScrapDetailIndex:
            if let index = notification.object {
                let scrap = viewModel.scraps.value[index as! Int]
                NotificationCenter.default.post(name: SparkyNotification.showOtherDetail, object: scrap)
            }
            break
        case SparkyNotification.sendOtherWebViewIndex:
            if let index = notification.object {
                let scrap = viewModel.scraps.value[index as! Int]
                NotificationCenter.default.post(name: SparkyNotification.showOtherWebView, object: scrap)
            }
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        viewModel.scraps.bind(to: otherScrapCollectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            
            let scrapLayoutStyle = ScrapLayoutStyle(rawValue:
                                                        row + 1 % 5) ?? ScrapLayoutStyle.horizontalOne
            
            switch scrapLayoutStyle {
            case .halfOne, .halfTwo:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HalfLayoutCell.identifier,
                    for: indexPath) as! HalfLayoutCell
                
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 8
                cell.setupValue(scrap: self.viewModel.scraps.value[row])
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.viewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag, pageType: .main)
                    }.disposed(by: self.disposeBag)
                cell.scrapDetailButton.tag = row
                cell.thumbnailImageView.tag = row
                return cell
                
            case .horizontalOne, .horizontalTwo:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HorizontalLayoutCell.identifier,
                    for: indexPath) as! HorizontalLayoutCell
                
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 8
                cell.setupValue(scrap: self.viewModel.scraps.value[row])
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.viewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag, pageType: .main)
                    }.disposed(by: self.disposeBag)
                cell.scrapDetailButton.tag = row
                cell.thumbnailImageView.tag = row
                return cell
                
            case .largeImage:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LargeImageLayoutCell.identifier,
                    for: indexPath) as! LargeImageLayoutCell
                
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 8
                cell.setupValue(scrap: self.viewModel.scraps.value[row])
                cell.tagCollectionView.delegate = nil
                cell.tagCollectionView.dataSource = nil
                self.viewModel.scraps.value[row].tagList.bind(to: cell.tagCollectionView.rx.items(
                    cellIdentifier: TagCollectionViewCell.identifier,
                    cellType: TagCollectionViewCell.self)) { index, tag, cell in
                        cell.setupConstraints()
                        cell.setupTagButton(tag: tag, pageType: .main)
                    }.disposed(by: self.disposeBag)
                cell.scrapDetailButton.tag = row
                cell.thumbnailImageView.tag = row
                return cell
            }
        }.disposed(by: disposeBag)
    }
}

extension OtherScrapCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scrapLayoutStyle = ScrapLayoutStyle(rawValue: indexPath.row + 1 % 5) ?? ScrapLayoutStyle.horizontalOne
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
