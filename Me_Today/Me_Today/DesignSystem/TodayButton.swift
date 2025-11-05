import SwiftUI

public struct TodayButton: View {
    let action: () -> Void
    let label: String

    init(
        action: @escaping () -> Void,
        label: String
    ) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .font(.pretendard(.semibold, size: 16))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.blue100)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
}
