//
//  ReIssueTokenResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/06.
//

struct ReIssueTokenResponse: Decodable {
    let code: String
    let message: String
    let result: token?
}

struct token: Decodable {
    let accessToken: String
}
