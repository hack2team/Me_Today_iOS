import SwiftUI

struct RadioButtonGroup: View {
    let options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack(spacing: 16) {
                        Image(selectedOption == option ? "checkBoxOn" : "checkBoxOff")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(option)
                            .font(.pretendard(.medium, size: 14))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedOption == option ? Color.blue50 : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray100, lineWidth: 0.2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
            }
        }
    }
}
