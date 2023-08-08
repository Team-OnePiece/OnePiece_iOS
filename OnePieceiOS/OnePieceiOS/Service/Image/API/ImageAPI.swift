import Foundation
import Moya

enum ImageAPI {
    case uploadImage(data: Data)
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        return "/user/image/upload"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .uploadImage(let data):
            var multiData: [MultipartFormData] = []
            multiData.append(
                .init(
                    provider: .data(data),
                    name: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpg"
                )
            )
            return .uploadMultipart(multiData)
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}

