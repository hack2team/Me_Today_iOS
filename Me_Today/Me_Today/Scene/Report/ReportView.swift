import SwiftUI
import Moya

struct ReportView: View {
    @State private var navigateToAi = false
    @State private var isLoading = false
    @State private var strengths: String = ""
    @State private var weaknesses: String = ""
    @State private var improvementSuggestions: String = ""
    @State private var relationshipMap: [String: String] = [:]
    
    // MoyaLoggingPlugin 적용
    private let provider = MoyaProvider<AnswerAPI>(plugins: [MoyaLoggingPlugin()])

    var body: some View {
        NavigationView {
            VStack {
                Image("reportIcon")
                    .padding(.top, 82)
                
                if isLoading {
                    ProgressView("리포트 제작 중...")
                        .padding()
                } else {
                    Button(action: {
                        makeReport()
                    }, label: {
                        Text("제작하기")
                            .font(.pretendard(.semibold, size: 16))
                            .padding(.vertical, 14)
                            .foregroundColor(.white)
                    })
                    .frame(width: 236)
                    .background(Color.blue100)
                    .cornerRadius(100)
                    .offset(y: -100)
                }
                
                NavigationLink(
                    destination: AiReportView(
                        strengths: strengths,
                        weaknesses: weaknesses,
                        improvementSuggestions: improvementSuggestions,
                        relationshipMap: relationshipMap
                    ),
                    isActive: $navigateToAi,
                    label: { EmptyView() }
                )
                .hidden()
            }
            .navigationTitle("리포트")
        }
    }
    
    func makeReport() {
        guard let userId = Token.userID else {
            print("⚠️ 사용자 ID를 찾을 수 없습니다.")
            return
        }
        
        isLoading = true
        
        provider.request(.report(userId: userId)) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(AnalysisResponse.self, from: response.data)
                        self.strengths = decoded.data?.strengths ?? "아직 충분한 데이터가 모이지 않았습니다"
                        self.weaknesses = decoded.data?.weaknesses ?? "아직 충분한 데이터가 모이지 않았습니다"
                        self.improvementSuggestions = decoded.data?.improvementSuggestions ?? "아직 충분한 데이터가 모이지 않았습니다"
                        self.relationshipMap = decoded.data?.relationshipMap ?? ["":"아직 충분한 데이터가 모이지 않았습니다"]
                        self.navigateToAi = true
                    } catch {
                        print("❌ 디코딩 실패: \(error)")
                    }
                case .failure(let error):
                    print("❌ API 호출 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
