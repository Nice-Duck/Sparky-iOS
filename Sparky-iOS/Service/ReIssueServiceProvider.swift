//
//  ReIssueServiceProvider.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/12.
//

import Moya
import RxSwift

struct ReIssueServiceProvider {
    static var shared = ReIssueServiceProvider()
    
    let provider = MoyaProvider<ReIssueServiceAPI>()
    let disposeBag = DisposeBag()
    
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
