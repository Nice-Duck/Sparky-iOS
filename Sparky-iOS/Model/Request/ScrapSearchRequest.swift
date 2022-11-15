//
//  ScrapSearchRequest.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/15.
//

import Foundation
import Moya

struct ScrapSearchRequest: Encodable {
    let tag: [Int]
    let title: String
    let type: Int
}

extension ScrapSearchRequest {
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
