//
//  MoveUtils.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/13.
//

import UIKit

final class MoveUtils {
    static let shared = MoveUtils()
    
     func moveToSignInVC() {
        let nav = UINavigationController(rootViewController: SignInVC())
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav
    }
    
    func moveToHomeVC() {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = SparkyTabBarController()
   }
}

