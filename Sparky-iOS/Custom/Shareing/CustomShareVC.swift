//
//  CustomShareVC.swift
//  Sparky
//
//  Created by SeungMin on 2022/09/14.
//

import UniformTypeIdentifiers
import MobileCoreServices
import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit

final class CustomShareVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let scrapView = UIView()
    private let scrapImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.circle")
    }
    private let scrapTitleLabel = UILabel().then {
        $0.text = "스으으으으으크크크크크크크크으으으으으으으으래래래래래애애애애애앱~~~~~"
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupNavBar()
        setupScrapView()
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            print("item is not nil")
            accessWebpageProperites(extentionItem: item)
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        
        let cancelbutton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(tapCancelbutton))
        //        cancelbutton.rx.tap.subscribe { _ in
        //            let error = NSError(domain: "sparky.bundle.identifier",
        //                                code: 0,
        //                                userInfo: [NSLocalizedDescriptionKey: "An error description"])
        //            self.extensionContext?.cancelRequest(withError: error)
        //        } onError: { error in
        //            print(error)
        //        }.disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = cancelbutton
        
        let saveButton = UIBarButtonItem(title: "저장하기",
                                         style: .plain,
                                         target: self,
                                         action: #selector(tapSavebutton))
        //        saveButton.rx.tap.subscribe { [unowned self] in
        //            self.extensionContext?.completeRequest(returningItems: [],
        //                                                   completionHandler: nil)
        //        } onError: { error in
        //            print(error)
        //        }.disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupScrapView() {
        self.view.addSubview(scrapView)
        scrapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-16)
            $0.height.equalTo(80)
        }
        
        self.scrapView.addSubview(scrapImageView)
        scrapImageView.snp.makeConstraints {
            $0.top.equalTo(scrapView.snp.top)
            $0.left.equalTo(scrapView.snp.left)
            $0.bottom.equalTo(scrapView.snp.bottom)
            $0.width.equalTo(80)
        }
        
        self.scrapView.addSubview(scrapTitleLabel)
        scrapTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrapView.snp.top)
            $0.left.equalTo(scrapImageView.snp.right).offset(16)
            $0.bottom.equalTo(scrapView.snp.bottom)
            $0.right.equalTo(scrapView.snp.right)
        }
        
        //        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
        //           let itemProviders = item.attachments {
        //            for itemProvider: NSItemProvider in itemProviders {
        //                print("Custom ShareVC itemProvider - \(itemProvider)")
        //
        //                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
        //                    print("itemProvider.hasItemConformingToTypeIdentifier is true")
        //
        //                    itemProvider.loadPreviewImage { image, error in
        //                        print("Custom ShareVC image - \(image)")
        //                        if let thumbnail = image as? UIImage {
        //                            self.scrapImageView.image = thumbnail
        //                        }
        //                    }
        //                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
        //                        print("Custom ShareVC url - \(url)")
        //                        if let scrapImageUrl = url as? NSURL {
        //                            print("Custom ShareVC scrapImageUrl - \(scrapImageUrl)")
        //                            self.scrapImageView.image = UIImage(data: try! Data(contentsOf: scrapImageUrl as URL))
        //                        }
        //                        //                      self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        //                        //                    }
        //                    }
        //                }
        //            }
        //
        //        }
    }
    
    private func accessWebpageProperites(extentionItem: NSExtensionItem) {
        var propertyList: String
        if #available(iOSApplicationExtension 14.0, *) {
            propertyList = String(UTType.propertyList.identifier)
        } else {
            propertyList = String(kUTTypePropertyList)
        }
        
        if let attachments = extentionItem.attachments {
            print("attachments is not nil")
            
            for attachment: NSItemProvider in attachments {
                print("attachment - \(attachment)")
                if attachment.hasItemConformingToTypeIdentifier("public.url") {
                    print("hasItemConformingToTypeIdentifier is true")
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                        print("loadItem")
                        print(url, error)
                        if let url = url as? NSURL {
                            DispatchQueue.main.async {
//                                self.scrapTitleLabel.text = url.path
                            }
                            
                        }
//                        guard let dictionary = url as? NSDictionary,
//                              let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
//                              let title = results["title"] as? String,
//                              let hostname = results["hostname"] as? String
//                        else {
//                            return
//                        }
                        
//                        let favicon = results["favicon"] as? String ?? "\(hostname)/favicon.ico"
//                        print("dictionary - \(dictionary)")
//                        print("results - \(results)")
//                        print("title - \(title)")
//                        print("hostname - \(hostname)")
//                        print("favicon - \(favicon)")
                    }
                }
            }
            
        }
    }
    
    
    @objc private func tapCancelbutton() {
        let error = NSError(domain: "sparky.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func tapSavebutton() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
}
