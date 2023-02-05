//
//  SparkyNotification.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/03.
//

import Foundation

struct SparkyNotification {
    
    // MyScrap Preview
    static let sendPreviewDetailIndex = Notification.Name(rawValue: "SendPreviewDetailIndex")
    static let sendPreviewWebViewIndex = Notification.Name(rawValue: "SendPreviewWebViewIndex")
    static let showPreviewDetail = Notification.Name(rawValue: "DidshowPreviewDetail")
    static let showPreviewWebView = Notification.Name(rawValue: "DidshowPreviewWebView")
    static let showScrapShareVC = Notification.Name(rawValue: "ShowScrapShareVC")
    
    // OtherScrap
    static let sendOtherScrapDetailIndex = Notification.Name(rawValue: "SendOtherScrapDetailIndex")
    static let sendOtherWebViewIndex = Notification.Name(rawValue: "SendOtherWebViewIndex")
    static let showOtherDetail = Notification.Name(rawValue: "DidshowOtherDetail")
    static let showOtherWebView = Notification.Name(rawValue: "DidshowOtherWebView")
    
    // MyScrap
    static let sendMyScrapDetailIndex = Notification.Name(rawValue: "SendMyScrapDetailIndex")
    static let sendMyScrapWebViewIndex = Notification.Name(rawValue: "SendMyScrapWebViewIndex")
    static let showMyScrapDetail = Notification.Name(rawValue: "DidshowMyScrapDetail")
    static let showMyScrapWebView = Notification.Name(rawValue: "DidshowMyScrapWebView")
}

