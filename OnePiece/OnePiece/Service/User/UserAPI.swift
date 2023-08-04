import Foundation
import Moya

enum UserAPI {
    case userInfoUpdate(userInfo: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.94.103:8080")!
    }
    
    var path: String {
        switch self {
        case .userInfoUpdate:
            return "/user/update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userInfoUpdate:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .userInfoUpdate(let nickName):
            return .requestParameters(
                parameters: [
                    "nickname": nickName
                ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}
