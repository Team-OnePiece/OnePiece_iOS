import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    var accountId: String?
    var password: String?
    var passwordValid: String?
    var nickName: String?
    var grade: Int?
    var classNumber: Int?
    var number: Int?
    
    private init() { }
}
