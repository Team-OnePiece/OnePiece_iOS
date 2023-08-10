import Foundation

struct TagResponse: Codable {
    let Id: Int
    
    enum CodingKeys: String, CodingKey {
        case Id = "tag_id"
    }
}
