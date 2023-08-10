import Foundation

struct UserInfoResponse: Decodable {
    let nickname: String
    let profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case profileImageURL = "profile_image_url"
    }
}
