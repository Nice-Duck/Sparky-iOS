//
//  ShareServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Moya

enum ShareServiceAPI {
    case saveTag(body: TagRequst)
    case fetchTag
    case saveScrap(body: ScrapRequest)
}

extension ShareServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }

    var path: String {
        switch self {
        case .saveTag:
            return "/tags"
        case .fetchTag:
            return "/tags"
        case .saveScrap:
            return "/scraps"
        }
    }


    var method: Moya.Method {
        switch self {
        case .saveTag:
            return .post
        case .fetchTag:
            return .get
        case .saveScrap:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .saveTag(let tagRequst):
            return .requestJSONEncodable(tagRequst)
        case .fetchTag:
            return .requestPlain
        case .saveScrap(body: let scrapRequest):
            return .requestJSONEncodable(scrapRequest)
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
