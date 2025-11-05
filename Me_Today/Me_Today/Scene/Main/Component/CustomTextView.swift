import SwiftUI

struct CustomTextView: View {
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.wantedSans(.regular, size: 14))
                .scrollContentBackground(.hidden)
                .frame(minHeight: 28)
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue100, lineWidth: 1)
                )
                .onChange(of: text) { newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.wantedSans(.regular, size: 14))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .allowsHitTesting(false)
            }
        }
    }
}
