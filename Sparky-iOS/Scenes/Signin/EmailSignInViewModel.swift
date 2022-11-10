//
//  EmailSignInViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import RxSwift
import RxCocoa

//struct Input {
//    let email = PublishSubject<String>()
//    let password = PublishSubject<String>()
//    let didTapEmailSignInButton = PublishSubject<Void>()
//}
//
//struct Output {
//    let enableEmailSignInButton = PublishRelay<Bool>()
//    let errorMessage = PublishRelay<String>()
//    let moveToHome = PublishRelay<Void>()
//}

//enum RegexType {
//    case email
//    case password
//
//    var value: String {
//        switch self {
//        case .email:
//            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        case .password:
//            return "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
//        }
//    }
//}

final class EmailSignInViewModel {
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    //    let input = Input()
    //    let output = Output()
    //    let disposeBag = DisposeBag()
    
    //    init() {
    //        input.didTapEmailSignInButton.withLatestFrom(Observable.combineLatest(input.email, input.password)).bind { email, password in
    //            if NSPredicate(format: "SELF MATCHES %@", RegexType.email.value).evaluate(with: email) && NSPredicate(format: "SELF MATCHES %@", RegexType.password.value).evaluate(with: password) {
    //                print("입력 오류")
    //            } else { self.output.moveToHome.accept(()) }
    //        }.disposed(by: disposeBag)
    //    }
    
    func isValidEmail() -> Observable<Bool> {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return Observable.combineLatest(emailObserver, passwordObserver).map { email, password in
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
                return true
            } else { return false }
        }.startWith(false)
    }
    
    func isValidPassword() -> Observable<Bool> {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        
        return Observable.combineLatest(emailObserver, passwordObserver).map { email, password in
            if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
                return true
            } else { return false }
        }.startWith(false)
    }
    
    func isValidSignInButton() -> Observable<Bool> {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        
        return Observable.combineLatest(emailObserver, passwordObserver).map { email, password in
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) && NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
                return true
            } else { return false }
        }
    }
}
