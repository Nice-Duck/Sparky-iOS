//
//  CustomShareNC.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/18.
//
 
import UIKit

@objc(CustomShareNC)
class CustomShareNC: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.setViewControllers([CustomShareVC()], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
