import SwiftUI

struct MainView: View {
    @State var questionNumber = "01"
    @State var question = "오늘 나의 에너지 수준은 어떠했나요?"
    @State private var height: CGFloat = 30
    @State var text: String = ""

    var body: some View {
        NavigationBarView()
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
                placeholder: "오늘 하루는 어땠나요?",
                characterLimit: 200
            )
            .padding(.horizontal, 20)

            ZStack {
                Image("circle")
                Image("mainBear")
            }
            TodayButton(action: {}, label: "제출하기")
        }
    }
}
