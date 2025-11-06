import Foundation

struct QuestionResponse: Codable {
    let success: Bool
    let data: QuestionData
}

struct QuestionData: Codable {
    let questionId: Int
    let content: String
    let createdBy: String
    let createdAt: String
}
