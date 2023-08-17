import Foundation
import Moya

enum StarAPI {
    case addStar(feedId: Int)
    case deleteStar(feedId: Int)
}

extension StarAPI: TargetType {
    var baseURL: URL {
        //        return URL(string: "http://54.180.94.103:8080")!
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .addStar(let feedId):
            return "/star/\(feedId)"
        case .deleteStar(let feedId):
            return "/star/\(feedId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addStar:
            return .post
        case .deleteStar:
            return .delete
        }
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
//        return Header.tokenIsEmpty.header()
        return Header.accessToken.header()
        
    }

}
