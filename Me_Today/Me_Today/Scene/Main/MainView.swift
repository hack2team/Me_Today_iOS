import SwiftUI

struct MainView: View {
    @Binding var selectedTab: Int
    @State var questionNumber = "01"
    @State var question = "오늘 나의 에너지 수준은 어떠했나요?"
    @State private var height: CGFloat = 30
    @State var text: String = ""
    @State private var navigateToFinish = false

    var body: some View {
        NavigationBarView()
        ZStack {
            if navigateToFinish {
                AnswerFinishView(selectedTab: $selectedTab)
                    .transition(.opacity.combined(with: .scale))
            } else {
                VStack {
                    HStack {
                        Text("Q\(questionNumber).")
                            .font(.wantedSans(.bold, size: 24))
                            .foregroundStyle(Color.blue100)
                        Text(question)
                            .font(.wantedSans(.semibold, size: 16))
                        Spacer()
                    }
                    .padding(.top, 60)
                    .padding(.leading, 20)

                    CustomTextView(
                        text: $text,
                        placeholder: question,
                        characterLimit: 200
                    )
                    .padding(.horizontal, 20)

                    ZStack {
                        Image("circle")
                        Image("mainBear")
                    }

                    TodayButton(action: {
                        sendAnswer(text: text)
                    }, label: "제출하기")
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: navigateToFinish)
    }

    func sendAnswer(text: String) {
        // API 로직 작성
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                navigateToFinish = true
            }
        }
    }
}
