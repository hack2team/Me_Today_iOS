import SwiftUI

struct AiReportView: View {
    let strengths: String
    let weaknesses: String
    let improvementSuggestions: String
    let relationshipMap: [String: String]
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("# 자아정체성 확립")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("답변")
                                .font(.pretendard(.semibold, size: 18))
                                .foregroundColor(.blue)
                            Text("을 분석하여")
                                .font(.pretendard(.semibold, size: 18))
                        }
                        Text("리포트로 만들었어요!")
                            .font(.pretendard(.semibold, size: 18))
                    }
                }
                .offset(x: -80)
                Image("ReportBear")
                    .offset(x: 80)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 16)

            VStack(spacing: 16) {
                ReportCard(
                    title: "장점",
                    titleColor: Color(red: 1.0, green: 0.4, blue: 0.5),
                    backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.95),
                    items: strengths
                )

                ReportCard(
                    title: "단점",
                    titleColor: Color(red: 0.4, green: 0.6, blue: 1.0),
                    backgroundColor: Color(red: 0.93, green: 0.95, blue: 1.0),
                    items: weaknesses
                )

                ReportCard(
                    title: "개선 사항",
                    titleColor: Color(red: 0.6, green: 0.5, blue: 1.0),
                    backgroundColor: Color(red: 0.95, green: 0.94, blue: 1.0),
                    items: improvementSuggestions
                )

                ReportCard2(
                    title: "나의 관계도",
                    titleColor: Color(red: 0.5, green: 0.8, blue: 0.4),
                    backgroundColor: Color(red: 0.95, green: 1.0, blue: 0.93),
                    items: relationshipMap  // 딕셔너리 그대로 전달
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .navigationTitle("리포트")
    }
}
