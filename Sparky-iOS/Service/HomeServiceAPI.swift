//
//  HomeServiceAPI.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/05.
//

import Moya

enum HomeServiceAPI {
    case saveTag(body: TagRequst)
    case fetchTag
    case fetchScraps(params: Int)
    case saveScrap(body: ScrapRequest)
    case patchScrap(body: ScrapRequest, params: Int)
    case removeScrap(params: Int)
    case scrapSearch(body: ScrapSearchRequest)
    case scrapURLCheck(params: String)
    case signOut
    case declaration(params: Int)
}

extension HomeServiceAPI: TargetType {
    var baseURL: URL { URL(string: "https://sparkyapi.tk/api/v1")! }
    
    var path: String {
        switch self {
        case .saveTag:
            return "/tags"
        case .fetchTag:
            return "/tags"
        case .fetchScraps:
            return "/scraps"
        case .saveScrap:
            return "/scraps"
        case .patchScrap:
            return "/scraps"
        case .removeScrap:
            return "/scraps"
        case .scrapSearch:
            return "/scraps/search"
        case .scrapURLCheck:
            return "/scraps/validation"
        case .signOut:
            return "/accounts"
        case .declaration:
            return "/scraps/declaration"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .saveTag:
            return .post
        case .fetchTag:
            return .get
        case .fetchScraps:
            return .get
        case .saveScrap:
            return .post
        case .patchScrap:
            return .patch
        case .removeScrap:
            return .delete
        case .scrapSearch:
            return .post
        case .scrapURLCheck:
            return .get
        case .signOut:
            return .delete
        case .declaration:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .saveTag(let tagRequst):
            return .requestJSONEncodable(tagRequst)
        case .fetchTag:
            return .requestPlain
        case .fetchScraps(let params):
            return .requestParameters(parameters: ["type": params], encoding: URLEncoding.queryString)
        case .saveScrap(let scrapRequest):
            return .requestJSONEncodable(scrapRequest)
        case .patchScrap(let scrapRequest, let params):
            return . requestCompositeData(bodyData: scrapRequest.encodableToData(), urlParameters: ["scrapId": params])
        case .removeScrap(params: let params):
            return .requestParameters(parameters: ["scrapId" : params], encoding: URLEncoding.queryString)
        case .scrapSearch(let scrapSearchRequest):
            return .requestJSONEncodable(scrapSearchRequest)
        case .scrapURLCheck(let params):
            return .requestParameters(parameters: ["url": params], encoding: URLEncoding.queryString)
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
