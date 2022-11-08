//
//  RecentTagViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import RxSwift
import RxCocoa

final class RecentTagViewModel {

    var recentTagList: BehaviorRelay<[Tag]> = BehaviorRelay(value: [])
//        Tag(text: "디자인", backgroundColor: .colorchip8, buttonType: .none),
//        Tag(text: "시각디자인", backgroundColor: .colorchip1, buttonType: .none),
//        Tag(text: "자료", backgroundColor: .colorchip2, buttonType: .none),
//        Tag(text: "인터뷰", backgroundColor: .colorchip3, buttonType: .none),
//        Tag(text: "인사이트", backgroundColor: .colorchip4, buttonType: .none),
//        Tag(text: "래퍼런스", backgroundColor: .colorchip5, buttonType: .none),
//        Tag(text: "디자인동아리", backgroundColor: .colorchip3, buttonType: .none),
//        Tag(text: "Sparky", backgroundColor: .colorchip4, buttonType: .none),
//        Tag(text: "나이스덕", backgroundColor: .colorchip6, buttonType: .none),
//        Tag(text: "리리", backgroundColor: .colorchip12, buttonType: .none),
//        Tag(text: "나인", backgroundColor: .colorchip11, buttonType: .none),
//        Tag(text: "헬리코박터프로젝트윌", backgroundColor: .colorchip10, buttonType: .none),
//        Tag(text: "창스", backgroundColor: .colorchip8, buttonType: .none),
//    ])
    
    var filterTagList: BehaviorRelay<[Tag]> = BehaviorRelay(value: [])
}
