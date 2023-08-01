import Foundation
import Moya

enum AuthAPI {
    case signup(UserInfo)
    case login(id: String, password: String)
    case idDuplicate(id: String)
    case nickNameDuplicate(nickName: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.94.103:8080")!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/user/signup"
        case .login:
            return "/user/login"
        case .idDuplicate:
            return "/user/id/duplicate"
        case .nickNameDuplicate:
            return "/user/nickname/duplicate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .login:
            return .post
        case .idDuplicate:
            return .get
        case .nickNameDuplicate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(_):
            return .requestParameters(
                parameters: [
                    "account_id": UserInfo.shared, //(아이디는 1~20자 영문 대 소문자, 숫자 사용하세요)
                    "password": UserInfo.shared,
                    "pasword_valid": UserInfo.shared,
                    "nickname": UserInfo.shared,
                    "grade": UserInfo.shared,  // (범위 1 ~ 3)
                    "class_number": UserInfo.shared,   // (범위 1 ~ 4)
                    "number": UserInfo.shared
                ], encoding: JSONEncoding.default)
        case .login(let id, let password):
            return .requestParameters(
                parameters: [
                    "account_id": id,
                    "password": password
                ], encoding: JSONEncoding.default)
        case .idDuplicate(let id):
            return .requestParameters(parameters: ["accountId": id], encoding: URLEncoding.queryString)
        case .nickNameDuplicate(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return Header.tokenIsEmpty.header()
    }
}
