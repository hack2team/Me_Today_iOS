import SwiftUI

struct ReportView: View {
    @State private var navigateToAi = false

    var body: some View {
        NavigationBarView()
        NavigationView {
            VStack {
                Image("reportIcon")
                    .padding(.top, 82)
                
                Button(action: {
                    makeReport()
                }, label: {
                    Text("제작하기")
                        .font(.pretendard(.semibold, size: 16))
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                })
                .frame(width: 236)
                .background(Color.blue100)
                .cornerRadius(100)
                .offset(y: -100)

                NavigationLink(
                    destination: AiReportView(),
                    isActive: $navigateToAi,
                    label: { EmptyView() }
                )
            }
        }
    }

    func makeReport() {
        // API 로직 작성
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                navigateToAi = true
            }
        }
    }
}
