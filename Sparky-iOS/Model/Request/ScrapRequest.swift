//
//  ScrapRequest.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

struct ScrapRequest: Encodable {
    let title: String
    let subTitle: String
    let memo: String
    let imgUrl: String
    let scpUrl: String
    let tagsResponse: [String]
}
