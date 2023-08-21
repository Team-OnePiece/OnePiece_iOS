import Foundation

struct AddStarResponse: Codable {
    let starCount: Int
    
    enum CodingKeys: String, CodingKey {
        case starCount = "star_count"
    }
}
