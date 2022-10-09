//
//  EmailSignUpResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/05.
//

struct EmailSignUpResponse: Decodable {
    let code: String
    let message: String
    let result: token?
}

struct result: Decodable {
    let refreshToken: String
    let accessToken: String
}
