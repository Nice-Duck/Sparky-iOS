//
//  ShareServiceProvider.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Moya
import RxSwift

struct ShareServiceProvider {
    static var shared = ShareServiceProvider()
    
    let provider = MoyaProvider<ShareServiceAPI>()
    let disposeBag = DisposeBag()
    
    func saveTag(tagRequst: TagRequst) -> Single<Response> {
        return provider.rx.request(.saveTag(body: tagRequst))
//            .filterSuccessfulStatusCodes()
            .do { response in
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response.statusCode)")
                }
            } onError: { error in
                print("요청 실패! - error: \(error)")
            }
    }
    
    func fetchTag() -> Single<Response> {
        return provider.rx.request(.fetchTag)
//            .filterSuccessfulStatusCodes()
            .do { response in
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response.statusCode)")
                }
            } onError: { error in
                print("요청 실패! - error: \(error)")
            }
    }
    
    func saveScrap(scrapRequest: ScrapRequest) -> Single<Response> {
        return provider.rx.request(.saveScrap(body: scrapRequest))
            .do { response in
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response.statusCode)")
                }
            } onError: { error in
                print("요청 실패! - error: \(error)")
            }
    }
}

