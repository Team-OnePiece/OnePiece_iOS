import Foundation

struct TagResponse: Codable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "tag_id"
    }
}
