import SwiftUI

struct PeriodSettingView: View {
    @State private var selectedPeriod: String = ""
    @State private var showPopup = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack (alignment: .leading ,spacing: 20) {
                        Text("다이어리의 기간을 선택해주세요")
                            .font(.pretendard(.bold, size: 20))
                            .padding(.leading, 30)
                        RadioButtonGroup(
                            options: ["3년", "2년", "6개월", "2개월"],
                            selectedOption: $selectedPeriod
                        )
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, 120)

                    Spacer()

                    TodayButton(action: {
                        showPopup = true
                    }, label: "다음")
                    .padding(.bottom, 70)
                }
                
                if showPopup {
                    let periodNumber = selectedPeriod.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    TodayPopup(
                        isPresented: $showPopup,
                        title: "안내",
                        message: "\(selectedPeriod)동안 같은 질문을 \(periodNumber)번 반복합니다.",
                        cancelButtonText: "취소",
                        confirmButtonText: "확인",
                        onConfirm: {
                            print("확인 버튼 클릭")
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    PeriodSettingView()
}
