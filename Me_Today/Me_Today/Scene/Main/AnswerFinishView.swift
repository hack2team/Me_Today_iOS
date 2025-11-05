import SwiftUI

struct AnswerFinishView: View {
    @Binding public var selectedTab: Int
    @State private var timer = "00:53:40"
    private var questionNumber = "01"
    private var question = "오늘 나의 에너지 수준은 어떠했나요?"
    private var answer = "답변 내용 답변 내용 답변 내용 답변 내용 답변 내용 답변 내용 답변 내용"
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("오늘의 답변을 완료 하셨어요!")
                            .font(.pyeongChang(.bold, size: 24))
                            .foregroundColor(.blue100)
                        
                        Text(timer)
                            .font(.wantedSans(.regular, size: 14))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 40)

                    Image("onboardingBear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .offset(y: -30)

                    HStack(spacing: 12) {
                        Button(action: {
                            selectedTab = 1
                        }) {
                            HStack(spacing: 8) {
                                Text("리포트")
                                    .font(.wantedSans(.semibold, size: 16))
                                Image("right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.blue100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.blue50)
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            selectedTab = 2
                        }) {
                            HStack(spacing: 8) {
                                Text("기록 보기")
                                    .font(.wantedSans(.semibold, size: 16))
                                Image("store")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.blue100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray50, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 40)

                    VStack(spacing: 8) {
                        Text("Q\(questionNumber). \(question)")
                            .font(.wantedSans(.regular, size: 14))
                            .foregroundColor(.black)
                        
                        Text(answer)
                            .font(.wantedSans(.regular, size: 14))
                            .foregroundColor(.gray100)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .background(Color.blue50.opacity(0.3))
                .padding(.horizontal, 20)
                .padding(.top, 46)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}
