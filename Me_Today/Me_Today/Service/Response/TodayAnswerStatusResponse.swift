import Foundation

struct TodayAnswerStatusResponse: Codable {
    let success: Bool
    let data: TodayAnswerStatusData
}

struct TodayAnswerStatusData: Codable {
    let userId: Int
    let answeredToday: Bool
    let lastAnsweredAt: String?
}
