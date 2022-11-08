//
//  HomeServiceProvider.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Moya
import RxSwift

struct HomeServiceProvider {
    static var shared = HomeServiceProvider()
    
    let provider = MoyaProvider<HomeServiceAPI>()
    let disposeBag = DisposeBag()
    
    func getAllScraps() -> Single<Response> {
        return provider.rx.request(.scraps(params: 0))
            .do { response in
                print(response)
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response)")
                }
            } onError: { error in
                print("onError - \(error)")
            }
    }
    
    func getMyScraps() -> Single<Response> {
        return provider.rx.request(.scraps(params: 1))
            .do { response in
                print(response)
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response)")
                }
            } onError: { error in
                print("onError - \(error)")
            }
    }
    
    func reissueAccesstoken() -> Single<Response> {
        return provider.rx.request(.reissueAccessToken)
            .do { response in
                print("response - \(response)")
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

