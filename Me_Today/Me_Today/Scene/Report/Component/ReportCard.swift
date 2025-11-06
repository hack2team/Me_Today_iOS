import SwiftUI

struct ReportCard: View {
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let items: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(titleColor)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(items)
                    .font(.wantedSans(.regular, size: 14))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(16)
    }
}

