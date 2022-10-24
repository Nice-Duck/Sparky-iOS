//
//  TagCollectionViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/11.
//

import UIKit
import RxSwift
import RxCocoa

final class TagCollectionViewModel {
    
    var recentTagList = BehaviorRelay<[Tag]>(value: [
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "시각디자인", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "자료", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "인터뷰", backgroundColor: .sparkyGreen, buttonType: .delete),
        Tag(text: "인사이트", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "래퍼런스", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "디자인동아리", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "Sparky", backgroundColor: .sparkyYellow, buttonType: .delete),
        Tag(text: "나이스덕", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "리리", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "나인", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "킹명주", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "창스", backgroundColor: .sparkyGreen, buttonType: .delete),
        Tag(text: "태그추가", backgroundColor: .clear, buttonType: .add)
    ])
    
    var filterTagList = BehaviorRelay<[Tag]>(value: [])
    
//    func convertNoneType(tagList: [Tag]) -> [Tag] {
//        var newTagList = recentTagList.values
//        if newTagList[newTagList.count - 1].buttonType == .add { newTagList.removeLast() }
//        
//        for i in 0..<newTagList.count {
//            newTagList[i] = Tag(text: newTagList[i].text,
//                             backgroundColor: newTagList[i].backgroundColor,
//                             buttonType: .none)
//        }
//        return newTagList
//    }
//
//    func convertDeleteType(tagList: [Tag]) -> [Tag] {
//        var newTagList = recentTagList.values
//        for i in 0..<newTagList.count {
//            newTagList[i] = Tag(text: newTagList[i].text,
//                             backgroundColor: newTagList[i].backgroundColor,
//                             buttonType: .none)
//        }
//        
//        let addButtonTag = Tag(text: "태그추가",
//                               backgroundColor: .clear,
//                               buttonType: .add)
//        newTagList.append(addButtonTag)
//        return newTagList
//    }
}
