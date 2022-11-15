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
    
    func getAllScraps() -> Single<Response> {
        return provider.rx.request(.fetchScraps(params: 0))
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
        return provider.rx.request(.fetchScraps(params: 1))
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
    
    func patchScrap(scrapRequest: ScrapRequest, scrapId: Int) -> Single<Response> {
        return provider.rx.request(.patchScrap(body: scrapRequest, params: scrapId))
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
    
    func removeScrap(scrapId: Int) -> Single<Response> {
        return provider.rx.request(.removeScrap(params: scrapId))
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
    
    func searchScrap(scrapSearchRequest: ScrapSearchRequest) -> Single<Response> {
        return provider.rx.request(.scrapSearch(body: scrapSearchRequest))
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
    
    func validateURL(urlString: String) -> Single<Response> {
        return provider.rx.request(.scrapURLCheck(params: urlString))
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
    
    func signOut() -> Single<Response> {
        return provider.rx.request(.signOut)
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
    
    func declaration(scrapId: Int) -> Single<Response> {
        return provider.rx.request(.declaration(params: scrapId))
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
}

