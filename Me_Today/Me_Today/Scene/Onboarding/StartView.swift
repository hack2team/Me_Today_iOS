import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            Image("background")
            VStack {
                Image("logoText")
                VStack (spacing: 0) {
                    Image("onboardingBear")
                    Button(action: {}, label: {
                        Text("시작하기")
                            .font(.pretendard(.semibold, size: 16))
                            .padding(.vertical, 17)
                            .frame(maxWidth: .infinity)
                    })
                    .foregroundStyle(Color.blue100)
                    .background(Color.white)
                    .cornerRadius(42)
                    .padding(.horizontal, 30)
                }
            }
        }
        .padding()
    }
}

#Preview {
    StartView()
}
