import SwiftUI

struct RecordView: View {
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    @State private var showRecordSheet = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    let answeredDates = [8, 9]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView()
                .padding(.bottom, 30)

            HStack (spacing: 60) {
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
                            if answeredDates.contains(Calendar.current.component(.day, from: date)) {
                                selectedDate = date
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
        .sheet(isPresented: $showRecordSheet) {
            RecordDetailSheet(date: selectedDate ?? Date(), answers: ["정말 재밋엇어용 굿굿 짱", "정말 재밋엇어용 굿굿 짱정말 재밋엇어용 굿굿 짱정말 재밋엇어용 굿굿 짱정말 재밋엇어용 굿굿 짱정말 재밋엇어용 굿굿 짱"])
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
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
}
