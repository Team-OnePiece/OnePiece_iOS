import Foundation
import Moya

enum FeedAPI {
    case createFeed(data: Data, place: String)
    case deleteFeed(feedId: Int)
    case loadFeed
    
}

extension FeedAPI: TargetType {
    
    var baseURL: URL {
//        return URL(string: "http://54.180.94.103:8080")!
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .createFeed:
            return "/feed"
        case .deleteFeed(let feedId):
            return "/feed/\(feedId)"
        case .loadFeed:
            return "/feed/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFeed:
            return .post
        case .deleteFeed:
            return .delete
        case .loadFeed:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createFeed(data: let data, let place):
            var multipart: [MultipartFormData] = []
            multipart.append(
                .init(
                    provider: .data(data),
                    name: "image",
                    fileName: "image.jpg",
                    mimeType: "image.jpg"
                )
            )
            return .uploadCompositeMultipart(multipart, urlParameters: ["place": place])
        case .deleteFeed:
            return .requestPlain
        case .loadFeed:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}
