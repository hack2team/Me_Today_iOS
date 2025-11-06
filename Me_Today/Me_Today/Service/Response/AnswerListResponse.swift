import Foundation

struct AnswerListResponse: Codable {
    let success: Bool
    let data: [Item]

    struct Item: Codable {
        let answerId: Int
        let userId: Int
        let questionId: Int
        let content: String
        let aiSummary: String
        let aiKeywords: String
        let createdAt: String
        let updatedAt: String

        enum CodingKeys: String, CodingKey {
            case answerId
            case userId
            case questionId
            case content
            case aiSummary
            case aiKeywords
            case createdAt
            case updatedAt
        }
    }

    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
}
