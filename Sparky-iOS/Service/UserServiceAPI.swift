//
//  UserServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import Moya

enum UserServiceAPI {
    case signIn(body: EmailSignInRequest)
    case signUpEmailDuplicate(params: String)
    case signUpEmailSend(body: EmailSendRequest)
    case signUpEmailConfirm(body: EmailConfirmRequest)
    case signUpNicknameDuplicate(params: EmailNicknameDuplicateRequest)
    case signUp(body: EmailSignUpRequest)
}

extension UserServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }
    
    var path: String {
        switch self {
        case .signIn:
            return "/accounts"
        case .signUpEmailDuplicate:
            return "/accounts/register"
        case .signUpEmailSend:
            return "/accounts/mails/send"
        case .signUpEmailConfirm:
            return "/accounts/mails/confirm"
        case .signUpNicknameDuplicate:
            return "/users/duplication"
        case .signUp:
            return "/accounts/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .signUpEmailDuplicate:
            return .get
        case .signUpEmailSend:
            return .post
        case .signUpEmailConfirm:
            return .post
        case .signUpNicknameDuplicate:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let emailsignInRequestModel):
            return .requestJSONEncodable(emailsignInRequestModel)
        case .signUpEmailDuplicate(let params):
            return .requestParameters(parameters: ["email": params], encoding: URLEncoding.queryString)
        case .signUpEmailSend(let emailSendRequest):
            return .requestJSONEncodable(emailSendRequest)
        case .signUpEmailConfirm(let emailConfirmRequest):
            return .requestJSONEncodable(emailConfirmRequest)
        case .signUpNicknameDuplicate(let params):
            return .requestParameters(parameters: ["name": params], encoding: URLEncoding.queryString)
        case .signUp(let emailSignUpRequest):
            return .requestJSONEncodable(emailSignUpRequest)
        }
    }
    
    //    var sampleData: Data {
    //        switch self {
    //        case .signIn(let emailsignInRequestModel):
    //            return "{\"id\": \(emailsignInRequestModel.email), \"password\":\(emailsignInRequestModel.password)}".utf8Encoded
    //        case .signUpEmailDuplicate(let params):
    //            <#code#>
    //        case .signUpEmailAuth(let body):
    //            <#code#>
    //        case .signUpNicknameDuplicate(let params):
    //            <#code#>
    //        case .signUp(let body):
    //            <#code#>
    //        }
    //    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data { Data(self.utf8)}
}
