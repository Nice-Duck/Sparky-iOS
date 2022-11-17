//
//  CustomActivityIndicatorView.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/17.
//

import UIKit

class CustomActivityIndicatorView: UIView {

    lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLoadingView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLoadingView() {
        self.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
