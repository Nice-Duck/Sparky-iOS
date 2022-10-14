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
}

struct Tag {
    let text: String
    let backgroundColor: UIColor
    let buttonType: ButtonType
}
