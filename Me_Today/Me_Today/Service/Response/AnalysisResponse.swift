import Foundation

struct AnalysisResponse: Codable {
    let success: Bool
    let data: AnalysisData
}

struct AnalysisData: Codable {
    let analysisId: Int
    let userId: Int
    let strengths: String
    let weaknesses: String
    let values: String
    let improvementSuggestions: String
    let relationshipMap: [String: String]
    let analyzedAt: String
}
