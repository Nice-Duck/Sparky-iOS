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
        Tag(text: "태그추가", backgroundColor: .clear, buttonType: .add)
    ])
}
