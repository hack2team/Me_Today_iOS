import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                VStack {
                    Image("logoText")
                    VStack(spacing: 0) {
                        Image("onboardingBear")
                        NavigationLink(destination: PeriodSettingView()) {
                            Text("시작하기")
                                .font(.pretendard(.semibold, size: 16))
                                .padding(.vertical, 17)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundStyle(Color.blue100)
                                .cornerRadius(42)
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    StartView()
}
