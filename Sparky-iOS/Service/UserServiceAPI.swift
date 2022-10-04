//
//  UserServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/02.
//

import Moya

enum UserServiceAPI {
    case signIn(body: EmailSignInRequest)
}

extension UserServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparky-demo.herokuapp.com")! }
    var path: String {
        switch self {
        case .signIn:
            return "/api/v1/accounts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let emailsignInRequestModel):
            return .requestJSONEncodable(emailsignInRequestModel)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .signIn(let emailsignInRequestModel):
            return "{\"id\": \(emailsignInRequestModel.email), \"password\": \(emailsignInRequestModel.password)}".utf8Encoded
        }
    }
    
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
