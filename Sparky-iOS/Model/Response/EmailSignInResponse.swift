//
//  EmailSignInResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

struct EmailSignInResponse: Decodable {
    let code: String
    let message: String
    let result: token?
}

struct token: Decodable {
    let accessToken: String?
    let refreshToken: String?
}

