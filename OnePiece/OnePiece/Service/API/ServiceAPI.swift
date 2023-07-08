import Foundation
import Moya

enum ServiceAPI {
    case login(id: String, password: String)
}

extension ServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http//:~~~")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/path"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let id, let password):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "password": password
                ],
                encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
