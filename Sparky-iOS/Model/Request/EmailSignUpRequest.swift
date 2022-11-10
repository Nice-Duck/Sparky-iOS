//
//  EmailSignUpRequest.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/05.
//

struct EmailSignUpRequest: Encodable {
    let email: String
    let pwd: String
    let nickname: String
}
