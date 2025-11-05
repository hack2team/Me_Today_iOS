import SwiftUI

struct ReportView: View {
    var body: some View {
        NavigationBarView()
        VStack {
            Image("reportIcon")
                .padding(.top, 82)
            Button(action: {}, label: {
                Text("제작하기")
                    .font(.pretendard(.semibold, size: 16))
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
            })
            .frame(width: 236)
            .background(Color.blue100)
            .cornerRadius(100)
            .offset(y: -100)
        }
    }
}
