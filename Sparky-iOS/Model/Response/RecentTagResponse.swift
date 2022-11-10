//
//  RecentTagResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

struct RecentTagResponse: Decodable {
    let code: String
    let message: String
    let result: RecentTagResult?
}

struct RecentTagResult: Decodable {
    let tagResponses: [TagResponse]
}
