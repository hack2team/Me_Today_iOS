import SwiftUI

struct AiReportView: View {
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("# 자아정체성 확립")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    VStack (alignment: .leading, spacing: 0) {
                        HStack (spacing: 0) {
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
                    items: "맡은 일을 끝까지 책임감 있게 해내며, 주변 사람들에게 배려심이 많고 긍정적인 태도로 분위기를 밝게 만드는 편이에요. "
                )

                ReportCard(
                    title: "단점",
                    titleColor: Color(red: 0.4, green: 0.6, blue: 1.0),
                    backgroundColor: Color(red: 0.93, green: 0.95, blue: 1.0),
                    items: "혼자서 너무 많은 일을 감당하려 하거나, 세세한 부분에 지나치게 신경 쓰는 경향이 있어요."
                )

                ReportCard(
                    title: "개선 사항",
                    titleColor: Color(red: 0.6, green: 0.5, blue: 1.0),
                    backgroundColor: Color(red: 0.95, green: 0.94, blue: 1.0),
                    items: "필요할 때는 주변에 도움을 요청하고, 완벽함보다는 효율을 우선으로 두는 연습이 필요해요."
                )

                ReportCard(
                    title: "나의 관계도",
                    titleColor: Color(red: 0.5, green: 0.8, blue: 0.4),
                    backgroundColor: Color(red: 0.95, green: 1.0, blue: 0.93),
                    items: "필요할 때는 주변에 도움을 요청하고, 완벽함보다는 효율을 우선으로 두는 연습이 필요해요."
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .navigationTitle("리포트")
    }
}
