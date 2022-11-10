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
    case authNumber
    
    var value: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .password:
            return "[A-Za-z0-9!_@$%^&+=]{8,20}"
        case .nickname:
            return "[가-힣A-Za-z0-9]{2,16}"
        case .authNumber:
            return "[0-9]{6,6}"
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
    var inputNumberObserver = BehaviorRelay<String>(value: "")
//    var inputNumber = Observable<String>.create { observer in
//        observer.onNext("")
//        return Disposables.create {
//            observer.onNext("")
//        }
//    }
    
    func isValid(regexType: RegexType) -> Observable<TextType> {
        return Observable.combineLatest(valueObserver, valueObserver).map { value1, value2 in
            if value1 != "" {
                if NSPredicate(format: "SELF MATCHES %@", regexType.value).evaluate(with: value1) {
                    return TextType.valid
                } else { return TextType.invalid }
            } else { return TextType.none }
        }.startWith(TextType.none)
    }
    
    func isValid(regexType: RegexType, textFieldColection: [OTPTextField]) -> Observable<TextType> {
        return Observable.combineLatest(textFieldColection[0].rx.text,
                                        textFieldColection[1].rx.text,
                                        textFieldColection[2].rx.text,
                                        textFieldColection[3].rx.text,
                                        textFieldColection[4].rx.text,
                                        textFieldColection[5].rx.text)
        .map { text in
            var input: String?
            guard let first = text.0 else { return TextType.invalid }
            guard let second = text.1 else { return TextType.invalid }
            guard let third = text.2 else { return TextType.invalid }
            guard let fourth = text.3 else { return TextType.invalid }
            guard let fifth = text.4 else { return TextType.invalid }
            guard let sixth = text.5 else { return TextType.invalid }
            
            input = first + second + third + fourth + fifth + sixth
            
            if let input = input {
                self.inputNumberObserver.accept(input)
                if NSPredicate(format: "SELF MATCHES %@", regexType.value).evaluate(with: input) {
                    return TextType.valid
                } else { return TextType.invalid }
            } else { return TextType.none }
            
        }.startWith(TextType.none)
    }
    
//    func getInputNumber(regexType: textFieldColection: [OTPTextField]) -> Observable<String> {
//        return Observable.combineLatest(textFieldColection[0].rx.text,
//                                        textFieldColection[1].rx.text,
//                                        textFieldColection[2].rx.text,
//                                        textFieldColection[3].rx.text,
//                                        textFieldColection[4].rx.text,
//                                        textFieldColection[5].rx.text)
//        .map { text in
//            var input: String?
//            guard let first = text.0 else { return ""}
//            guard let second = text.1 else { return "" }
//            guard let third = text.2 else { return "" }
//            guard let fourth = text.3 else { return "" }
//            guard let fifth = text.4 else { return "" }
//            guard let sixth = text.5 else { return "" }
//            
//            input = first + second + third + fourth + fifth + sixth
//            if let input = input {
//                if NSPredicate(format: "SELF MATCHES %@", regexType.value).evaluate(with: input) {
//                    return input
//                } else { return "" }
//            } else { return "" }
//            
//        }.startWith("")
//    }
}
