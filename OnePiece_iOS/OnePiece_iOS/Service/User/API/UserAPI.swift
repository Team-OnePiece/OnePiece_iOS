import Foundation
import Moya

enum UserAPI {
    case userInfoUpdate(userInfo: String)
    case userInfoLoad
}

extension UserAPI: TargetType {
    var baseURL: URL {
//        return URL(string: "http://54.180.94.103:8080")!
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .userInfoUpdate:
            return "/user/update"
        case .userInfoLoad:
            return "/user/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userInfoUpdate:
            return .patch
        case .userInfoLoad:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .userInfoUpdate(let nickName):
            return .requestParameters(
                parameters: [
                    "nickname": nickName
                ], encoding: JSONEncoding.default)
        case .userInfoLoad:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}
