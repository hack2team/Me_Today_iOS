import SwiftUI

private struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isTabBarHidden: Binding<Bool> {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

struct TabbarView: View {
    @State private var selectedTab = 0
    @State private var isTabbarHidden = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                contentView(for: selectedTab)
                    .environment(\.isTabBarHidden, $isTabbarHidden)
                
                Spacer(minLength: 0)
                
                if !isTabbarHidden {
                    customTabbar
                }
            }
        }
    }

    private var customTabbar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                tabItem(icon: "tabbarPencil", index: 0, label: "답변")
                Spacer()
                tabItem(icon: "tabbarReport", index: 1, label: "리포트")
                Spacer()
                tabItem(icon: "tabbarRecord", index: 2, label: "기록")
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 52)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func contentView(for tab: Int) -> some View {
        switch tab {
        case 0:
            MainView(selectedTab: $selectedTab)
        case 1:
            ReportView()
        case 2:
            RecordView()
        default:
            EmptyView()
        }
    }

    func tabItem(icon: String, index: Int, label: String) -> some View {
        VStack {
            Image(icon)
                .renderingMode(.template)
                .foregroundColor(selectedTab == index ? .blue100 : .gray)
            Text(label)
                .font(.wantedSans(.semibold, size: 12))
                .foregroundColor(selectedTab == index ? .blue100 : .gray)
        }
        .onTapGesture {
            selectedTab = index
        }
    }
}

#Preview {
    TabbarView()
}
