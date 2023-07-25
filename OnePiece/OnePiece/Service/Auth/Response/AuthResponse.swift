import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let expiredAt: Int
}
//서버에서 보내주는 body랑 맞추기
