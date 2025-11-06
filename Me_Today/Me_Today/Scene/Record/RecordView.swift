import SwiftUI
import Moya

struct RecordView: View {
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    @State private var showRecordSheet = false
    @State private var answers: [AnswerListResponse.Item] = []
    @State private var answeredDates: Set<Date> = []
    @State private var selectedAnswers: [AnswerListResponse.Item] = []
    @State private var selectedQuestionTitle: String = "질문"
    
    private let provider = MoyaProvider<AnswerAPI>(plugins: [MoyaLoggingPlugin()])
    private let questionProvider = MoyaProvider<QuestionAPI>(plugins: [MoyaLoggingPlugin()])
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView()
                .padding(.bottom, 30)

            HStack(spacing: 60) {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }

                Text(monthYearString)
                    .font(.wantedSans(.semibold, size: 18))

                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.wantedSans(.regular, size: 14))
                        .foregroundColor(.gray100)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isAnswered: answeredDates.contains(Calendar.current.startOfDay(for: date)),
                            isSelected: selectedDate == date
                        )
                        .onTapGesture {
                            if answeredDates.contains(Calendar.current.startOfDay(for: date)) {
                                selectedDate = date
                                selectedAnswers = getAnswersForDate(date)
                                loadQuestionTitle(for: date)
                                showRecordSheet = true
                            }
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .onAppear {
            loadAnswers()
        }
        .onChange(of: currentMonth) { _ in
            loadAnswers()
        }
        .sheet(isPresented: $showRecordSheet) {
            if let date = selectedDate {
                RecordDetailSheet(
                    date: date,
                    answers: selectedAnswers,
                    questionTitle: selectedQuestionTitle
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월"
        return formatter.string(from: currentMonth)
    }
    
    var daysInMonth: [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstWeekday = Calendar.current.component(.weekday, from: monthInterval.start)
        let numDays = Calendar.current.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day ?? 0
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 0..<numDays {
            if let date = Calendar.current.date(byAdding: .day, value: day, to: monthInterval.start) {
                days.append(date)
            }
        }
        
        return days
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func loadAnswers() {
        guard let userId = Token.userID else {
            print("⚠️ userID가 없습니다.")
            return
        }
        
        provider.request(.question(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(AnswerListResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.answers = data.data
                        print("✅ 답변 \(data.data.count)개 로드 완료")
                        self.updateAnsweredDates()
                    }
                } catch {
                    print("❌ 디코딩 실패: \(error)")
                }
            case .failure(let error):
                print("❌ API 호출 실패: \(error)")
            }
        }
    }
    
    func loadQuestionTitle(for date: Date) {
        // 해당 날짜의 첫 번째 답변에서 questionId 가져오기
        let answersForDate = getAnswersForDate(date)
        guard let firstAnswer = answersForDate.first else {
            selectedQuestionTitle = "질문"
            return
        }
        
        let questionId = firstAnswer.questionId
        
        questionProvider.request(.questionTitle(id: questionId)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(QuestionResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.selectedQuestionTitle = data.data.content
                        print("✅ 질문 제목 로드 완료: \(data.data.content)")
                    }
                } catch {
                    print("❌ 질문 제목 디코딩 실패: \(error)")
                    DispatchQueue.main.async {
                        self.selectedQuestionTitle = "질문"
                    }
                }
            case .failure(let error):
                print("❌ 질문 제목 API 호출 실패: \(error)")
                DispatchQueue.main.async {
                    self.selectedQuestionTitle = "질문"
                }
            }
        }
    }
    
    func parseDate(_ dateString: String) -> Date? {
        let formats = ["yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }

    func updateAnsweredDates() {
        var dates = Set<Date>()
        let calendar = Calendar.current
        
        let currentYear = calendar.component(.year, from: currentMonth)
        let currentMonthComponent = calendar.component(.month, from: currentMonth)

        for answer in answers {
            if let date = parseDate(answer.createdAt) {
                let answerMonth = calendar.component(.month, from: date)
                let answerDay = calendar.component(.day, from: date)
                
                if answerMonth == currentMonthComponent {
                    var components = DateComponents()
                    components.year = currentYear
                    components.month = answerMonth
                    components.day = answerDay
                    
                    if let normalizedDate = calendar.date(from: components) {
                        let startOfDay = calendar.startOfDay(for: normalizedDate)
                        dates.insert(startOfDay)
                        print("✅ 저장된 날짜:", startOfDay, "원본:", answer.createdAt)
                    }
                }
            } else {
                print("❌ 날짜 파싱 실패:", answer.createdAt)
            }
        }

        answeredDates = dates
        print("📅 answeredDates:", answeredDates)
    }
    
    func getAnswersForDate(_ date: Date) -> [AnswerListResponse.Item] {
        let calendar = Calendar.current
        let selectedMonth = calendar.component(.month, from: date)
        let selectedDay = calendar.component(.day, from: date)
        
        return answers.filter { answer in
            if let answerDate = parseDate(answer.createdAt) {
                let answerMonth = calendar.component(.month, from: answerDate)
                let answerDay = calendar.component(.day, from: answerDate)
                return answerMonth == selectedMonth && answerDay == selectedDay
            }
            return false
        }
    }
}
