//
//  UserServiceProvider.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import Moya
import RxSwift

final class UserServiceProvider {
    static var shared = UserServiceProvider()
    
    let provider = MoyaProvider<UserServiceAPI>()
    let disposeBag = DisposeBag()   
    
    func signIn(emailSignInRequestModel: EmailSignInRequest) -> Single<Response> {
//    -> Single<Response> {
//                completion: @escaping (Result<EmailSignInResponse, Error>) -> Void) {
        return provider.rx.request(.signIn(body: emailSignInRequestModel))
//            .filterSuccessfulStatusCodes()
//            .map(EmailSignInResponse.self)
//            .asObservable()
            .do { response in
                print("요청 성공! - HTTP Status Code: \(response.statusCode)")
            } onError: { error in
                print("요청 실패! - error: \(error)")
            }
            
//            .subscribe { response in
//                print(response)
//                print("🔑 response.accessToken - \(response.result?.accessToken)")
//                print("🔑 response.refreshToken - \(response.result?.refreshToken)")
//            } onFailure: { error in
//                print(error)
//            }.disposed(by: disposeBag)
//        return Disposables.create()
    }
}

