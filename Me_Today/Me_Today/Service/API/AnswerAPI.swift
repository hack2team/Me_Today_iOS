import Foundation
import Moya
internal import Alamofire


enum AnswerAPI {
    case answerSend(userId: String, questionId: Int, content: String)
    case report(userId: String)
    case today(userId: String)
    case question(userId: String)
}

extension AnswerAPI: TargetType {
    var baseURL: URL {
        return URL(string: Secrets.baseURL)!
    }

    var path: String {
        switch self {
        case .answerSend:
            return "/answers"
        case let .report(userId):
            return "/answers/report/\(userId)"
        case .today:
            return "/answers/today"
        case let .question(userId):
            return "/answers/user/\(userId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .answerSend:
            return .post
        case .report, .today, .question:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .answerSend(userId, questionId, content):
            return .requestParameters(
                parameters: [
                    "userId": userId,
                    "questionId": questionId,
                    "content": content
                ], encoding: JSONEncoding.default)
        case .report, .question:
            return .requestPlain
        case let.today(userId):
            return .requestParameters(
                parameters: ["userId": userId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return Header.tokenIsEmpty.header()
    }
}
