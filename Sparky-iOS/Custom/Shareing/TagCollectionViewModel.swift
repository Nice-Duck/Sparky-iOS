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
    
    func didTapDeleteButton(index: Int) {
        var tagListCopy = self.tagList.value
        tagListCopy.remove(at: index)
        self.tagList.accept(tagListCopy)
    }
    
    func didTapAddButton(vc: UIViewController) {
        let tagBottomSheetVC = TagBottomSheetVC()
        tagBottomSheetVC.modalPresentationStyle = .overFullScreen
        vc.present(tagBottomSheetVC, animated: false)
    }
}
