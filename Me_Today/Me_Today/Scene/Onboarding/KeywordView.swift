import SwiftUI

struct KeywordView: View {
    let selectedPeriod: String
    @State private var selectedKeyword: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack (alignment: .leading ,spacing: 20) {
                        Text("어떤 사람이 되고 싶나요?")
                            .font(.pretendard(.bold, size: 20))
                            .padding(.leading, 30)
                        RadioButtonGroup(
                            options: ["꾸준히 성장하는 사람", "일에서 성장하고 싶은 사람", "좋은 사람, 좋은 관계를 만들고 싶은 사람", "진짜 나를 알고 싶은 사람"],
                            selectedOption: $selectedKeyword
                        )
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, 120)

                    Spacer()

                    TodayButton(action: {
                        setting(period: selectedPeriod, keyword: selectedKeyword)
                    }, label: "다음")
                    .padding(.bottom, 70)
                }
            }
        }
    }

    func setting(period: String, keyword: String) {
        // API 로직 작성
    }
}
