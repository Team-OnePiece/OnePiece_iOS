import Foundation
import Moya

enum GroupAPI {
    case loadGroup
}

extension GroupAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        return "/group"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
    
    
}
