//
//  SparkyNotification.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/03.
//

import Foundation

struct SparkyNotification {
    static let sendScrapDetailIndex = Notification.Name(rawValue: "SendScrapDetailIndex")
    static let sendScrapWebViewIndex = Notification.Name(rawValue: "SendScrapWebViewIndex")
    static let showScrapDetail = Notification.Name(rawValue: "DidShowScrapDetail")
    static let showScrapWebView = Notification.Name(rawValue: "DidShowScrapWebView")
}

