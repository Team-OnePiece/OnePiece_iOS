import Foundation

struct GroupResponse: Codable {
    let grade: Int
    let classnumber: Int
    
    enum CodingKeys: String, CodingKey {
        case grade
        case classnumber = "class_number"
    }
}
