import Foundation


struct AnswerSendResponse: Codable {
    let success: Bool
    let data: AnswerData
}

struct AnswerData: Codable {
    let answerId: Int
    let prevAnswer: String?
    let savedAt: String
}
