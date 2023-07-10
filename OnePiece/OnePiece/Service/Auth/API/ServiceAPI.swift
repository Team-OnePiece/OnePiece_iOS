import Foundation
import Moya

enum ServiceAPI {
    case signup(id: String, password: String, nickName: String, profile: String, schoolNumber: Int, classNumber: Int, studentNumber: Int)
    case login(id: String, password: String)
}

extension ServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http//:192.168.1.23:8080")!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/user"
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
        case .signup(let id, let password, let nickName, let profile, let schoolNumber, let classNumber, let studentNumber):
            return .requestParameters(
                parameters: [
                    "userId": id, //(아이디는 1~20자 영문 대 소문자, 숫자 사용하세요)
                      "userPassword": password, //(비밀번호는 1~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요)
                      "nickName": nickName, //(닉네임은 특수문자, 숫자를 제외한 2~9자 한글 영문 대 소문자 사용하세요)
                      "profile": profile,
                      "schoolNumber": studentNumber,  // (범위 1 ~ 3)
                      "classNumber": classNumber,   // (범위 1 ~ 4)
                      "studentNumber": studentNumber  // (범위 1 ~ 18)
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
