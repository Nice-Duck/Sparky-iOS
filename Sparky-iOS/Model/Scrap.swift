//
//  Scraps.swift
//  Sparky
//
//  Created by SeungMin on 2022/10/04.
//

import Foundation
import RxRelay

struct Scraps {
    let myScraps: BehaviorRelay<[Scrap]>
    let otherScraps: BehaviorRelay<[Scrap]>
}

struct Scrap {
    let scrapId: Int
    let title: String
    let subTitle: String
    let memo: String
    let thumbnailURLString: String
    let scrapURLString: String
    let tagList: BehaviorRelay<[Tag]>
}
