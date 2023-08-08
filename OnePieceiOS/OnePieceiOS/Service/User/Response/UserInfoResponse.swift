import Foundation

struct UserInfoResponse: Decodable {
    let nickname: String
    let userImage: String
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case userImage = "profile_image_url"
    }
}
