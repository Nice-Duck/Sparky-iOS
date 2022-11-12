//
//  Scraps.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/12.
//

import RxRelay

struct Scraps {
    let myScraps: BehaviorRelay<[Scrap]>
    let otherScraps: BehaviorRelay<[Scrap]>
}
