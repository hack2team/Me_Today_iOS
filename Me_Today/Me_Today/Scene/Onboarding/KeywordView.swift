import SwiftUI
import Moya
internal import Alamofire

struct KeywordView: View {
    let selectedPeriod: String
    @State private var selectedKeyword: String = ""
    @State private var navigateToTabbar = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack (alignment: .leading ,spacing: 20) {
                        Text("어떤 사람이 되고 싶나요?")
                            .font(.pretendard(.bold, size: 20))
                            .padding(.leading, 30)
                        RadioButtonGroup(
                            options: ["도전형", "자율형", "관계형", "탐구형"],
                            selectedOption: $selectedKeyword
                        )
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, 120)

                    Spacer()

                    TodayButton(action: {
                        let periodInMonths: Int = {
                            if selectedPeriod.contains("년") {
                                let numberString = selectedPeriod.replacingOccurrences(of: "년", with: "")
                                return (Int(numberString) ?? 0) * 12
                            } else if selectedPeriod.contains("개월") {
                                let numberString = selectedPeriod.replacingOccurrences(of: "개월", with: "")
                                return Int(numberString) ?? 0
                            } else {
                                return 0
                            }
                        }()
                        setting(period: periodInMonths, keyword: selectedKeyword)
                    }, label: "다음")
                    .padding(.bottom, 70)
                }
            }
            .fullScreenCover(isPresented: $navigateToTabbar) {
                TabbarView()
            }
        }
    }

    func setting(period: Int, keyword: String) {
        let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])

        provider.request(.userSend(
            name: "",
            age: 0,
            email: "",
            password: "",
            planDurationMonths: period,
            idealPersonDescription: keyword
        )) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try JSONDecoder().decode(UserSendResponse.self, from: response.data)
                    if response.statusCode == 201 {
                        Token.userID = "\(data.data.userId)"
                        
                        DispatchQueue.main.async {
                            self.navigateToTabbar = true
                        }
                    } else {
                        print("error - 상태 코드: \(response.statusCode)")
                    }
                } catch {
                    print("JSON 파싱 실패: \(error)")
                }

            case let .failure(error):
                print("호출 실패: \(error)")
            }
        }
    }
}
