//
//  TagSaveResponse.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/12.
//

struct TagSaveResponse: Decodable {
    let code: String
    let message: String
    let result: TagResponse?
}
