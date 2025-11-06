import Foundation

struct AnswerListResponse: Codable {
    let success: Bool
    let data: [AnswerData]
}

struct AnswerData: Codable {
    let answerId: Int
    let userId: Int
    let questionId: Int
    let content: String
    let aiSummary: String
    let aiKeywords: String
    let createdAt: String
    let updatedAt: String
}
