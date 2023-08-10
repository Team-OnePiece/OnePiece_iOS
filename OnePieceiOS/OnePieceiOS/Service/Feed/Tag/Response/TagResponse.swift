import Foundation

struct TagResponse: Codable {
    let tagId: Int
    
    enum CodingKeys: String, CodingKey {
        case tagId = "tag_id"
    }
}
