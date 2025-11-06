import Foundation
import Moya
internal import Alamofire

enum QuestionAPI {
    case todayQuestion(userId: String)
    case questionTitle(id: Int)
}

extension QuestionAPI: TargetType {
    var baseURL: URL {
        return URL(string: Secrets.baseURL)!
    }
    
    var path: String {
        switch self {
        case .todayQuestion:
            return "/questions/today"
        case let .questionTitle(id):
            return "/questions/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todayQuestion, .questionTitle:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .todayQuestion(userId):
            return .requestParameters(
                parameters: ["userId": userId],
                encoding: URLEncoding.default
            )
        case .questionTitle:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.tokenIsEmpty.header()
    }
}
