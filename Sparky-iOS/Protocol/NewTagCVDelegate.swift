//
//  NewTagCVDelegate.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/12.
//

protocol NewTagCVDelegate: AnyObject {
    func sendNewTagList(tag: Tag)
}

protocol DismissVCDelegate: AnyObject {
    func sendNotification()
}
