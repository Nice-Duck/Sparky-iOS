//
//  ScrapSearchRequest.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

import Foundation
import Moya

struct ScrapSearchRequest: Encodable {
    let tags: [Int]
    let title: String
    let type: Int
}
