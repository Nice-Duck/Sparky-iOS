//
//  TagResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

struct TagResponse: Decodable {
    let tagId: Int
    let name: String
    let color: String?
}
