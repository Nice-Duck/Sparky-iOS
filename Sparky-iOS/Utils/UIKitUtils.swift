//
//  UIKitUtils.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/10.
//

import UIKit

final class UIKitUtils {
    
    static var parentWindow: UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = scene?.windows.first
        return window
    }
    
    static var statusBarHeight: CGFloat {
        print("status bar height - \(UIKitUtils.parentWindow?.windowScene?.statusBarManager?.statusBarFrame.height)")
        return UIKitUtils.parentWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var navBarHeight: CGFloat {
        let nav = UINavigationController()
        print("nav bar height - \(nav.navigationBar.frame.height)")
        return nav.navigationBar.frame.height
    }
}
