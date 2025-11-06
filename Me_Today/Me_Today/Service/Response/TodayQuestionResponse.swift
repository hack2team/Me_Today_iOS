import Foundation

struct TodayQuestionResponse: Codable {
    let success: Bool
    let data: TodayQuestionData
}

struct TodayQuestionData: Codable {
    let question: Question?
    let answeredCount: Int?
    let totalQuestions: Int?
    let remainingQuestions: Int?
}

struct Question: Codable {
    let questionId: Int
    let content: String
    let createdBy: String
    let createdAt: String
}
