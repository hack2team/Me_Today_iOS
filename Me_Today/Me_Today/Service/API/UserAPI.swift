import SwiftUI
import Moya
internal import Alamofire

enum UserAPI {
    case userSend(name: String, age: Int, email: String, password: String, planDurationMonths: Int, idealPersonDescription: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: Secrets.baseURL)!
    }

    var path: String {
        switch self {
        case .userSend:
            return "/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .userSend:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .userSend(_, _, _, _, planDurationMonths, idealPersonDescription):
            return .requestParameters(
                parameters: [
                    "name": "이름",
                    "age": 18,
                    "email": "이메일",
                    "password": "비밀번호",
                    "planDurationMonths":planDurationMonths,
                    "idealPersonDescription": idealPersonDescription
                ], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return Header.tokenIsEmpty.header()
        }
    }
}
