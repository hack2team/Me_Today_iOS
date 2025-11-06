import SwiftUI
import Moya

struct MainView: View {
    @Binding var selectedTab: Int
    @State private var navigateToFinish = false
    @State var questionNumber = ""
    @State var question = ""
    @State private var text: String = ""
    @State var questionId = 0
    @State private var isLoading = true
    
    private let provider = MoyaProvider<AnswerAPI>(plugins: [MoyaLoggingPlugin()])

    var body: some View {
        NavigationBarView()
        ZStack {
            if isLoading {
                Color.blue50.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
            } else if navigateToFinish {
                AnswerFinishView(selectedTab: $selectedTab)
                    .transition(.opacity.combined(with: .scale))
            } else {
                mainQuestionView
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: navigateToFinish)
        .animation(.easeInOut(duration: 0.3), value: isLoading)
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
        guard let userId = Token.userID else {
            isLoading = false
            return
        }

        provider.request(.today(userId: userId)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    do {
                        let data = try JSONDecoder().decode(TodayAnswerStatusResponse.self, from: response.data)
                        
                        if data.data.answeredToday {
                            // 오늘 이미 답변함 -> FinishView로
                            self.isLoading = false
                            withAnimation {
                                self.navigateToFinish = true
                            }
                        } else {
                            // 오늘 답변 안함 -> 질문 로드
                            self.loadTodayQuestion()
                        }
                    } catch {
                        print("❌ JSON 파싱 실패: \(error)")
                        self.isLoading = false
                    }
                case let .failure(error):
                    print("❌ API 호출 실패: \(error)")
                    self.isLoading = false
                }
            }
        }
    }

    func loadTodayQuestion() {
        guard let userId = Token.userID else {
            isLoading = false
            return
        }

        let provider = MoyaProvider<QuestionAPI>(plugins: [MoyaLoggingPlugin()])
        
        provider.request(.todayQuestion(userId: userId)) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case let .success(response):
                    do {
                        let data = try JSONDecoder().decode(TodayQuestionResponse.self, from: response.data)
                        
                        if let questionData = data.data.question {
                            self.question = questionData.content
                            self.questionNumber = String((data.data.answeredCount ?? 0) + 1).padLeft(totalWidth: 2)
                            self.questionId = questionData.questionId
                        } else {
                            print("⚠️ 질문이 없습니다.")
                            withAnimation {
                                self.navigateToFinish = true
                            }
                        }
                    } catch {
                        print("❌ JSON 파싱 실패: \(error)")
                    }
                case let .failure(error):
                    print("❌ API 호출 실패: \(error)")
                }
            }
        }
    }

    func sendAnswer(text: String) {
        guard let userId = Token.userID else { return }

        provider.request(.answerSend(userId: userId, questionId: questionId, content: text)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 201 {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.navigateToFinish = true
                        }
                    }
                } else {
                    print("❌ 상태 코드: \(response.statusCode)")
                }
            case let .failure(error):
                print("❌ API 호출 실패: \(error)")
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
