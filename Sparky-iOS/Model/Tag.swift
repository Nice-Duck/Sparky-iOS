//
//  tag.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/11.
//

import UIKit

enum ButtonType {
    case delete
    case add
    case none
}

struct Tag: Equatable {
    let name: String
    let color: UIColor
    var buttonType: ButtonType
}
