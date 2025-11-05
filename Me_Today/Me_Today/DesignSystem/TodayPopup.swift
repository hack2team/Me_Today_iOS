import SwiftUI

struct TodayPopup: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let cancelButtonText: String
    let confirmButtonText: String
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack(alignment: .leading, spacing: 24) {
                Text(title)
                    .font(.pretendard(.bold, size: 22))
                    .foregroundColor(.black)
                
                Text(message)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 12) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text(cancelButtonText)
                            .font(.pretendard(.semibold, size: 16))
                            .foregroundColor(.blue100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.gray50)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        onConfirm()
                        isPresented = false
                    }) {
                        Text(confirmButtonText)
                            .font(.pretendard(.medium, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue100)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(28)
            .padding(.horizontal, 45)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .ignoresSafeArea()
    }
}
