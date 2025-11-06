import SwiftUI

struct ReportCard2: View {
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let items: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(titleColor)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(items.keys.sorted()), id: \.self) { key in
                    HStack(spacing: 4) {
                        Text("-")
                            .foregroundColor(.gray)
                        Text("\(key): \(items[key] ?? "")")
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(16)
    }
}
