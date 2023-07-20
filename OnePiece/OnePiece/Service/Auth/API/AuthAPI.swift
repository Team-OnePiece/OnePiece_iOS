import Foundation
import Moya

enum AuthAPI {
    case signup(id: String, password: String, passwordValid: String,nickName: String, profile: String, grade: Int, classNumber: String, number: Int)
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
        case .signup(let id, let password, let passwordValid, let nickName, let profile, let grade, let classNumber, let number):
            return .requestParameters(
                parameters: [
                    "accountId": id, //(아이디는 1~20자 영문 대 소문자, 숫자 사용하세요)
                    "password": password,
                    "paswordValid": passwordValid,
                    "nickName": nickName,
                    "profileImage": profile,
                    "grade": grade,  // (범위 1 ~ 3)
                    "classNumber": classNumber,   // (범위 1 ~ 4)
                    "number": number
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
