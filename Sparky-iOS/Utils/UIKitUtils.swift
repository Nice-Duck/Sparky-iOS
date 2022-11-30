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
}
