//
//  HomeServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Moya

enum HomeServiceAPI {
    case scraps(params: Int)
    case reissueAccessToken
}

extension HomeServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }
    
    var path: String {
        switch self {
        case .scraps:
            return "/scraps"
        case .reissueAccessToken:
            return "/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .scraps:
            return .get
        case .reissueAccessToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .scraps(let params):
            return .requestParameters(parameters: ["type": params], encoding: URLEncoding.queryString)
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
