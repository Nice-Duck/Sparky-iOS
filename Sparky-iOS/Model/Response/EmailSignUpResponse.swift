//
//  EmailSignUpResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/05.
//

struct EmailSignUpResponse: Decodable {
    let code: String
    let message: String
    let result: tokens?
}

struct tokens: Decodable {
    let accessToken: String
    let refreshToken: String
}
