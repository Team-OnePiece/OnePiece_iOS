import Foundation
import Moya

enum TagAPI {
    case addTag(tag: String, feedId: Int)
    case deleteTag(tagId: Int)
//    case loadTag(
}

extension TagAPI: TargetType {
    var baseURL: URL {
//        return URL(string: "http://54.180.94.103:8080")!
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .addTag(_, let feedId):
            return "/tag/\(feedId)"
        case .deleteTag(let tagId):
            return "/tag/\(tagId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addTag:
            return .post
        case .deleteTag:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addTag(let tag, _):
            return .requestParameters(
                parameters: [
                    "tag": tag
                ], encoding: JSONEncoding.default)
        case .deleteTag:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
    
}
