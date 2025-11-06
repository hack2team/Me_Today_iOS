import SwiftUI
import Moya

struct MainView: View {
    @Binding var selectedTab: Int
    @State private var navigateToFinish = false
    @State var questionNumber = ""
    @State var question = ""
    @State private var text: String = ""
    @State var questionId = 0
    
    private let provider = MoyaProvider<AnswerAPI>(plugins: [MoyaLoggingPlugin()])

    var body: some View {
        NavigationBarView()
        ZStack {
            if navigateToFinish {
                AnswerFinishView(selectedTab: $selectedTab)
                    .transition(.opacity.combined(with: .scale))
            } else {
                mainQuestionView
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: navigateToFinish)
        .onAppear {
            checkTodayAnswered()
        }
    }
    
    var mainQuestionView: some View {
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
                placeholder: "자신만의 답변을 작성해보세요!",
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
    }

    func checkTodayAnswered() {
        guard let userId = Token.userID else { return }

        provider.request(.today(userId: "\(userId)")) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try JSONDecoder().decode(TodayAnswerStatusResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        if data.data.answeredToday {
                            withAnimation {
                                self.navigateToFinish = true
                            }
                        } else {
                            loadTodayQuestion()
                        }
                    }
                } catch {
                    print("JSON 파싱 실패: \(error)")
                }
            case let .failure(error):
                print("API 호출 실패: \(error)")
            }
        }
    }

    func loadTodayQuestion() {
        guard let userId = Token.userID else { return }

        provider.request(.today(userId: "\(userId)")) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try JSONDecoder().decode(TodayQuestionResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        if let questionData = data.data.question {
                            self.question = questionData.content
                            self.questionNumber = String((data.data.answeredCount ?? 0) + 1).padLeft(totalWidth: 2)
                            self.questionId = questionData.questionId
                        } else {
                            self.navigateToFinish = true
                        }
                    }
                } catch {
                    print("JSON 파싱 실패: \(error)")
                }
            case let .failure(error):
                print("API 호출 실패: \(error)")
            }
        }
    }

    func sendAnswer(text: String) {
        guard let userId = Token.userID else { return }

        provider.request(.answerSend(userId: userId, questionId: questionId, content: text)) { result in
            switch result {
            case let .success(response):
                do {
                    if response.statusCode == 201 {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.navigateToFinish = true
                            }
                        }
                    } else {
                        print("❌ 상태 코드: \(response.statusCode)")
                    }
                } catch {
                    print("JSON 파싱 실패: \(error)")
                }
            case let .failure(error):
                print("API 호출 실패: \(error)")
            }
        }
    }
}
extension String {
    func padLeft(totalWidth: Int, with character: Character = "0") -> String {
        if count >= totalWidth { return self }
        return String(repeating: String(character), count: totalWidth - count) + self
    }
}
