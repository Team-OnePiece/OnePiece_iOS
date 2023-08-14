import Foundation

struct CreateFeedResponse: Decodable {
    let feedId: Int
    
    enum CodingKeys: String, CodingKey {
        case feedId = "feed_id"
    }
}
