//
//  RecentTagViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import RxSwift
import RxCocoa

final class RecentTagViewModel {

    var recentTagList: BehaviorRelay<[Tag]> = BehaviorRelay(value: [
        Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .none),
        Tag(text: "시각디자인", backgroundColor: .sparkyPink, buttonType: .none),
        Tag(text: "자료", backgroundColor: .sparkyBlue, buttonType: .none),
        Tag(text: "인터뷰", backgroundColor: .sparkyGreen, buttonType: .none),
        Tag(text: "인사이트", backgroundColor: .sparkyPink, buttonType: .none),
        Tag(text: "래퍼런스", backgroundColor: .sparkyBlue, buttonType: .none),
        Tag(text: "디자인동아리", backgroundColor: .sparkyOrange, buttonType: .none),
        Tag(text: "Sparky", backgroundColor: .sparkyYellow, buttonType: .none),
        Tag(text: "나이스덕", backgroundColor: .sparkyBlue, buttonType: .none),
        Tag(text: "리리", backgroundColor: .sparkyOrange, buttonType: .none),
        Tag(text: "나인", backgroundColor: .sparkyPink, buttonType: .none),
        Tag(text: "헬리코박터프로젝트윌", backgroundColor: .sparkyBlue, buttonType: .none),
        Tag(text: "창스", backgroundColor: .sparkyGreen, buttonType: .none),
    ])
    
    var filterTagList: BehaviorRelay<[Tag]> = BehaviorRelay(value: [])
}
