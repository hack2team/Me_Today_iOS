import Foundation

struct UserSendResponse: Codable {
    let success: Bool
    let data: UserData
}

struct UserData: Codable {
    let userId: Int
    let name: String
    let age: Int
    let email: String
    let createdAt: String
    let planDurationMonths: Int
}
