import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let expiredAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiredAt = "expired_at"
    }
}
//서버에서 보내주는 body랑 맞추기
