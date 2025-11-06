import SwiftUI

struct DayCell: View {
    let date: Date
    let isAnswered: Bool
    let isSelected: Bool
    
    var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        ZStack {
            Text("\(dayNumber)")
                .font(.wantedSans(.regular, size: 16))
                .foregroundColor(.black)
                .frame(height: 40)
            
            if isAnswered {
                Circle()
                    .fill(Color.blue100)
                    .frame(width: 6, height: 6)
                    .offset(y: 16)
            }
        }
    }
}

struct RecordDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let date: Date
    let answers: [AnswerListResponse.Item]
    @State var questionTitle = "질문"
    
    func formatAnswerDate(_ dateString: String) -> String {
        let formats = ["yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
                return formatter.string(from: date)
            }
        }
        return dateString
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(questionTitle)
                .font(.pretendard(.bold, size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .padding(.top, 40)
            
            if answers.isEmpty {
                Spacer()
                Text("답변이 없습니다.")
                    .font(.wantedSans(.regular, size: 16))
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(answers.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(formatAnswerDate(answers[index].createdAt))
                                        .font(.pretendard(.semibold, size: 14))
                                        .foregroundColor(.black)
                                    
                                    if answers.count > 1 {
                                        Text("(\(index + 1)/\(answers.count))")
                                            .font(.pretendard(.medium, size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Text(answers[index].content)
                                    .font(.wantedSans(.regular, size: 14))
                                    .foregroundColor(.black)
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray100, lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            
            Spacer()
            
            TodayButton(action: {
                dismiss()
            }, label: "닫기")
            .padding(.bottom, 20)
            
        }
        .background(Color.white)
    }
}
