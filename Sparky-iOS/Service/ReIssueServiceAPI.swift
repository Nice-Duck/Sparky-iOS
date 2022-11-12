//
//  ReIssueServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/12.
//

import Moya

enum ReIssueServiceAPI {
    case reissueAccessToken
}

extension ReIssueServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }
    
    var path: String {
        switch self {
        case .reissueAccessToken:
            return "/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reissueAccessToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .reissueAccessToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json",
                "Authorization": TokenUtils().getAuthorizationHeaderString()]
    }
}

private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data { Data(self.utf8)}
}
