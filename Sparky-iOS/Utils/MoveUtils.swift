//
//  MoveUtils.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/13.
//

import UIKit

final class MoveUtils {
    static let shared = MoveUtils()
    
    func moveToSignInVC(nav: UINavigationController?) {
        
//         if let nav = nav {
//             for vc in nav.viewControllers {
//     //            if vc.isKind(of: )
//                 vc.removeFromParent()
//             }
//         }
//        nav?.viewControllers.removeAll()
//        nav?.setViewControllers([SignInVC()], animated: false)
//        UIApplication.shared.windows.first?.removeFromSuperview()
        nav?.viewControllers.removeAll()
        let nav = UINavigationController(rootViewController: SignInVC())
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav
    }
    
    func moveToHomeVC(nav: UINavigationController?) {
//        if let nav = nav {
//            for vc in nav.viewControllers {
//    //            if vc.isKind(of: )
//                vc.removeFromParent()
//            }
//        }
//        nav?.viewControllers.removeAll()
//        nav?.setViewControllers([SparkyTabBarController()], animated: false)
//        UIApplication.shared.windows.first?.removeFromSuperview()
        nav?.viewControllers.removeAll()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = SparkyTabBarController()
   }
}

