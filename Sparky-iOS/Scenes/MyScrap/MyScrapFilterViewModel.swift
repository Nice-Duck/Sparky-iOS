//
//  MyScrapFilterViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

import RxRelay

final class MyScrapFilterViewModel {
    
    var filterTagList = BehaviorRelay<[Tag]>(value: [
        Tag(tagId: -1,
            name: "필터",
            color: .sparkyOrange,
            buttonType: .add)
    ])
}

