//
//  OtherScrapViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/31.
//

import RxRelay

final class OtherScrapViewModel {
    
    var otherScrapList: BehaviorRelay<[Scrap]> = BehaviorRelay(value: [
        Scrap(title: "실험이 중요한 이유",
              subTitle: "어쩔티비 뇌절티비123",
              memo: "마음의 여백이 없는 삭막한 사람일수록 자신이 잘난 줄 착각하고 용서와 화해에 인색합니다.",
              thumbnailURLString: "http://www.weeklyseoul.net/news/photo/201905/51464_22692_4445.jpg",
              scrapURLString: "https://greenletters.tistory.com/355",
              tagList: BehaviorRelay(value:[Tag(text: "디자인", backgroundColor: .sparkyOrange, buttonType: .none), Tag(text: "시각디자인", backgroundColor: .sparkyPink, buttonType: .none)])),
        Scrap(title: "실험이 중요한 이유",
              subTitle: "어쩔티비 뇌절티비123",
              memo: "마음의 여백이 없는 삭막한 사람일수록 자신이 잘난 줄 착각하고 용서와 화해에 인색합니다.",
              thumbnailURLString: "http://www.weeklyseoul.net/news/photo/201905/51464_22692_4445.jpg",
              scrapURLString: "https://greenletters.tistory.com/355",
              tagList: BehaviorRelay(value: [Tag(text: "자료", backgroundColor: .sparkyBlue, buttonType: .none),
                                             Tag(text: "인터뷰", backgroundColor: .sparkyGreen, buttonType: .none),
                                             Tag(text: "인사이트", backgroundColor: .sparkyPink, buttonType: .none)])),
        Scrap(title: "실험이 중요한 이유",
              subTitle: "어쩔티비 뇌절티비123",
              memo: "마음의 여백이 없는 삭막한 사람일수록 자신이 잘난 줄 착각하고 용서와 화해에 인색합니다.",
              thumbnailURLString: "http://www.weeklyseoul.net/news/photo/201905/51464_22692_4445.jpg",
              scrapURLString: "https://greenletters.tistory.com/355",
              tagList: BehaviorRelay(value: [Tag(text: "래퍼런스", backgroundColor: .sparkyBlue, buttonType: .none),
                                             Tag(text: "디자인동아리", backgroundColor: .sparkyOrange, buttonType: .none),
                                             Tag(text: "Sparky", backgroundColor: .sparkyYellow, buttonType: .none),
                                             Tag(text: "나이스덕", backgroundColor: .sparkyBlue, buttonType: .none),
                                             Tag(text: "리리", backgroundColor: .sparkyOrange, buttonType: .none)])),
        Scrap(title: "실험이 중요한 이유",
              subTitle: "어쩔티비 뇌절티비123",
              memo: "마음의 여백이 없는 삭막한 사람일수록 자신이 잘난 줄 착각하고 용서와 화해에 인색합니다.",
              thumbnailURLString: "http://www.weeklyseoul.net/news/photo/201905/51464_22692_4445.jpg",
              scrapURLString: "https://greenletters.tistory.com/355",
              tagList: BehaviorRelay(value: [Tag(text: "나인", backgroundColor: .sparkyPink, buttonType: .none),
                                             Tag(text: "헬리코박터프로젝트윌", backgroundColor: .sparkyBlue, buttonType: .none),
                                             Tag(text: "창스", backgroundColor: .sparkyGreen, buttonType: .none)]))
    ])
}
