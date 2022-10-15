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
    var tagList = BehaviorRelay<[Tag]>(value: [
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "기획", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "개발개발개", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "기획고", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "개", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "기획", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "개발", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .delete),
        Tag(text: "기획", backgroundColor: .sparkyPink, buttonType: .delete),
        Tag(text: "개발", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "개발", backgroundColor: .sparkyBlue, buttonType: .delete),
        Tag(text: "태그추가", backgroundColor: .clear, buttonType: .add)
        ]
    )
    
    func removeTag(index: Int) {
        var tagListCopy = self.tagList.value
        tagListCopy.remove(at: index)
        self.tagList.accept(tagListCopy)
    }
}
