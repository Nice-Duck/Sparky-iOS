//
//  ScrapSearchResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

struct ScrapSearchResponse: Decodable {
    let code: String
    let message: String
    let result: [ScrapItem]?
}
