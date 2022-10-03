//
//  NextButtonViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/03.
//

import RxSwift
import RxCocoa

enum RegexType {
    case email
    case password
    case nickname

    var value: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .password:
            return "[A-Za-z0-9!_@$%^&+=]{8,20}"
        case .nickname:
            return "[가-힣A-Za-z0-9]{2,16}"
        }
    }
}

enum TextType {
    case none
    case valid
    case invalid
}

final class SignUpViewModel {
    let valueObserver = BehaviorRelay<String>(value: "")

    func isValid(regexType: RegexType) -> Observable<TextType> {
        return Observable.combineLatest(valueObserver, valueObserver).map { value1, value2 in
            if value1 != "" {
                if NSPredicate(format: "SELF MATCHES %@", regexType.value).evaluate(with: value1) {
                    return TextType.valid
                } else { return TextType.invalid }
            } else { return TextType.none }
        }.startWith(TextType.none)
    }
    
//    func isValid(regexType: RegexType) -> Observable<TextType> {
//        return Observable.combineLatest(valueObserver, valueObserver).map { value1, value2 in
//            if NSPredicate(format: "SELF MATCHES %@", regexType.value).evaluate(with: value1) {
//                return true
//            } else { return false }
//        }.startWith(false)
//    }
}
