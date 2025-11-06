import SwiftUI

struct KeywordView: View {
    let selectedPeriod: String
    @State private var selectedKeyword: String = ""
    @State private var navigateToTabbar = false

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
                        setting(period: selectedPeriod, keyword: selectedKeyword)
                    }, label: "다음")
                    .padding(.bottom, 70)
                }
            }
            .fullScreenCover(isPresented: $navigateToTabbar) {
                TabbarView()
            }
        }
    }

    func setting(period: String, keyword: String) {
        // API 로직 작성
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                navigateToTabbar = true
            }
        }
    }
}
