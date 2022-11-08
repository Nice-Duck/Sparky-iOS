//
//  AddTagViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/11.
//

import UIKit
import RxSwift
import RxCocoa

final class AddTagViewModel {
    
    var addTagList = BehaviorRelay<[Tag]>(value: [
        Tag(name: "태그추가", color: .clear, buttonType: .add)
    ])
}
