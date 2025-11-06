import Foundation
import Moya
internal import Alamofire

enum QuestionAPI {
    case todayQuestion(userId: String)
}

extension QuestionAPI: TargetType {
    var baseURL: URL {
        return URL(string: Secrets.baseURL)!
    }
    
    var path: String {
        switch self {
        case .todayQuestion:
            return "/questions/today"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todayQuestion:
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
        }
    }
    
    var headers: [String : String]? {
        return Header.tokenIsEmpty.header()
    }
}
