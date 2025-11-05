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
    let answers: [String] // 서버에서 받은 답변 배열
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 답변 내용"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("질문 답변 기록")
                .font(.pretendard(.bold, size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .padding(.top, 40)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(answers.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(dateString.replacingOccurrences(of: "답변 내용", with: "\(index + 1)번째 답변"))")
                                .font(.pretendard(.semibold, size: 14))
                                .foregroundColor(.black)
                            
                            Text(answers[index])
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
