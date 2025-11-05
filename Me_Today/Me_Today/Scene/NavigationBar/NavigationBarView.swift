import SwiftUI

struct NavigationBarView: View {
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Image("logo")
                Spacer()
            }
            .padding(20)
            Divider()
        }
    }
}
