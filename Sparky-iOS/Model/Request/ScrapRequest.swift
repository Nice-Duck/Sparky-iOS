//
//  ScrapRequest.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Foundation
import Moya

struct ScrapRequest: Encodable {
    let title: String
    let subTitle: String
    let memo: String
    let imgUrl: String
    let scpUrl: String
    let tags: [Int]
}

extension ScrapRequest {
    func encodableToData() -> Data {
        let jsonEncoder = JSONEncoder()
        var data = Data()
        do {
            data = try jsonEncoder.encode(self)
        } catch {
            print("data 타입으로 변환 불가!")
        }
        return data
    }
}
