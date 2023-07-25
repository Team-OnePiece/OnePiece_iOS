import Foundation
import Moya

enum AuthAPI {
    case signup(UserInfo)
    case login(id: String, password: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/user/signup"
        case .login:
            return "/user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(_):
            return .requestParameters(
                parameters: [
                    "accountId":UserInfo.shared, //(아이디는 1~20자 영문 대 소문자, 숫자 사용하세요)
                    "password": UserInfo.shared,
                    "paswordValid": UserInfo.shared,
                    "nickName": UserInfo.shared,
                    "grade": UserInfo.shared,  // (범위 1 ~ 3)
                    "classNumber": UserInfo.shared,   // (범위 1 ~ 4)
                    "number": UserInfo.shared
                ], encoding: JSONEncoding.default)
        case .login(let id, let password):
            return .requestParameters(
                parameters: [
                    "accountId": id,
                    "password": password
                ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
