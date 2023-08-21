import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let expiredAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiredAt = "expired_at"
    }
}
