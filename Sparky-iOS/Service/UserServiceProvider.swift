//
//  UserServiceProvider.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import Moya
import RxSwift

struct UserServiceProvider {
    static var shared = UserServiceProvider()
    
    let provider = MoyaProvider<UserServiceAPI>()
    let disposeBag = DisposeBag()
    
    func signIn(emailSignInRequestModel: EmailSignInRequest) -> Single<Response> {
        return provider.rx.request(.signIn(body: emailSignInRequestModel))
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
    
    func patchPassword(emailSignInRequestModel: EmailSignInRequest) -> Single<Response> {
        return provider.rx.request(.patchPassword(body: emailSignInRequestModel))
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
    
    func signUpEmailDuplicate(email: String) -> Single<Response> {
        return provider.rx.request(.signUpEmailDuplicate(params: email))
            .do { response in
                if (200...299).contains(response.statusCode) {
                    print("요청 성공! - HTTP Status Code: \(response.statusCode)")
                } else {
                    print("요청 실패! - HTTP Status Code: \(response.statusCode)")
                }
            } onError: { error in
                print("요청 실패! - endPoint: \(error)")
            }
    }
    
    func signUpEmailSend(emailSendRequest: EmailSendRequest) -> Single<Response> {
        return provider.rx.request(.signUpEmailSend(body: emailSendRequest))
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
    
    func signUpEmailConfirm(emailConfirmRequest: EmailConfirmRequest) -> Single<Response> {
        return provider.rx.request(.signUpEmailConfirm(body: emailConfirmRequest))
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
    
    func signUpNicknameDuplicate(nicknameDuplicateRequest: EmailNicknameDuplicateRequest) -> Single<Response> {
        return provider.rx.request(.signUpNicknameDuplicate(params: nicknameDuplicateRequest))
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
    
    func signUp(emailSignUpRequest: EmailSignUpRequest) -> Single<Response> {
        return provider.rx.request(.signUp(body: emailSignUpRequest))
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

