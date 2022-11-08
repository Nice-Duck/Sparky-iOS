//
//  ScrapResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

struct ScrapResponse: Decodable {
    let code: String
    let message: String
    let result: ScrapResult?
}

struct ScrapResult: Decodable {
    let myScraps: [ScrapItem]?
    let recScraps: [ScrapItem]?
}

struct ScrapItem: Decodable {
    let type: Int
    let scrapId: Int
    let title: String?
    let subTitle: String?
    let memo: String?
    let imgUrl: String?
    let scpUrl: String?
    let tagsResponse: [TagResponse]?
}
