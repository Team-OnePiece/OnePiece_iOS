import Foundation
import Moya

enum ServiceAPI {
    case signup(id: String, password: String)
    case signup2(nickName: String, profile: String, schoolNumber: Int, classNumber: String, studentNumber: Int)
    case login(id: String, password: String)
}

extension ServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http//:192.168.1.23:8080")!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/user/signup"
        case .signup2:
            return "/user/signup"
        case .login:
            return "/user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .signup2:
            return .post
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(let id, let password):
            return .requestParameters(
                parameters: [
                    "userId": id, //(아이디는 1~20자 영문 대 소문자, 숫자 사용하세요)
                    "userPassword": password
                ], encoding: JSONEncoding.default)
        case .signup2(let nickName, let profile, let schoolNumber, let classNumber, let studentNumber):
            return .requestParameters(
                parameters: [
                    "nickName": nickName,
                    "profile": profile,
                    "schoolNumber": studentNumber,  // (범위 1 ~ 3)
                    "classNumber": classNumber,   // (범위 1 ~ 4)
                    "studentNumber": studentNumber
                ], encoding: JSONEncoding.default)
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
