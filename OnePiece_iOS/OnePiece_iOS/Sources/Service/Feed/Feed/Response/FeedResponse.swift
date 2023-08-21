import Foundation

struct FeedResponseElement: Codable {
    let id: Int
    let place: String
    let feedImageurl: String
    let feedDate: String
    let nickname: String
    let feedProfileImageurl: String
    let grade: Int
    let classnumber: Int
    let number: Int
    
    enum CodingKeys: String, CodingKey {
        case id, place, nickname, grade, number
        case feedImageurl = "board_image_url"
        case feedDate = "create_at"
        case feedProfileImageurl = "profile_image_url"
        case classnumber = "class_number"
    }
}
typealias FeedResponse = [FeedResponseElement]
