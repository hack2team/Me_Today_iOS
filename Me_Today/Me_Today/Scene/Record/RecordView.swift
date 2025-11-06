import SwiftUI
import Moya

struct RecordView: View {
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    @State private var showRecordSheet = false
    @State private var answers: [AnswerListResponse.Item] = []
    @State private var answeredDates: Set<Int> = []
    @State private var selectedAnswers: [AnswerListResponse.Item] = []
    
    private let provider = MoyaProvider<AnswerAPI>(plugins: [MoyaLoggingPlugin()])
    
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
                            isAnswered: answeredDates.contains(Calendar.current.component(.day, from: date)),
                            isSelected: selectedDate == date
                        )
                        .onTapGesture {
                            let day = Calendar.current.component(.day, from: date)
                            if answeredDates.contains(day) {
                                selectedDate = date
                                selectedAnswers = getAnswersForDate(date)
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
                RecordDetailSheet(date: date, answers: selectedAnswers)
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
    
    func updateAnsweredDates() {
        // "2025-11-06T06:28:16" 형식을 파싱할 수 있는 DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        
        var dates = Set<Int>()
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentMonth)
        let currentMonthNumber = calendar.component(.month, from: currentMonth)
        
        for answer in answers {
            if let date = dateFormatter.date(from: answer.createdAt) {
                let answerYear = calendar.component(.year, from: date)
                let answerMonth = calendar.component(.month, from: date)
                let answerDay = calendar.component(.day, from: date)
                
                print("📅 파싱된 날짜: \(answerYear)-\(answerMonth)-\(answerDay)")
                
                // 현재 표시 중인 월과 같은지 확인
                if answerYear == currentYear && answerMonth == currentMonthNumber {
                    dates.insert(answerDay)
                    print("✅ 날짜 추가: \(answerDay)일")
                }
            } else {
                print("❌ 날짜 파싱 실패: \(answer.createdAt)")
            }
        }
        
        answeredDates = dates
        print("📊 답변 있는 날짜들: \(answeredDates.sorted())")
    }
    
    func getAnswersForDate(_ date: Date) -> [AnswerListResponse.Item] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        
        let calendar = Calendar.current
        
        return answers.filter { answer in
            if let answerDate = dateFormatter.date(from: answer.createdAt) {
                return calendar.isDate(answerDate, inSameDayAs: date)
            }
            return false
        }
    }
}
