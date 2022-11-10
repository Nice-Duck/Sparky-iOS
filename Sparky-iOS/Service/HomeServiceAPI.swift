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
    case signOut
    case declaration(params: Int)
}

extension HomeServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }
    
    var path: String {
        switch self {
        case .scraps:
            return "/scraps"
        case .reissueAccessToken:
            return "/token"
        case .signOut:
            return "/accounts"
        case .declaration:
            return "/scraps/declaration"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .scraps:
            return .get
        case .reissueAccessToken:
            return .post
        case .signOut:
            return .delete
        case .declaration:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .scraps(let params):
            return .requestParameters(parameters: ["type": params], encoding: URLEncoding.queryString)
        case .reissueAccessToken:
            return .requestPlain
        case .signOut:
            return .requestPlain
        case .declaration(let params):
            return .requestParameters(parameters: ["scrapId": params], encoding: URLEncoding.queryString)
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
