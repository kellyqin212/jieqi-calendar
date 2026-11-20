import SwiftUI

struct RootView: View {
    let launch: LaunchConfiguration
    @StateObject private var purchases = PurchaseManager()

    var body: some View {
        Group {
            switch launch.screenshot {
            case .home, .festival:
                HomeView()
            case .term:
                TermDetailScreen()
            case .month:
                MonthCalendarView()
            case .about:
                AboutView()
            case .widgets:
                WidgetPreviewView()
            case nil:
                TabView {
                    HomeView()
                        .tabItem { Label("今日", systemImage: "sun.max") }
                    MonthCalendarView()
                        .tabItem { Label("月历", systemImage: "calendar") }
                    AboutView()
                        .tabItem { Label("关于", systemImage: "info.circle") }
                }
                .tint(Theme.cinnabar)
            }
        }
        .environment(\.almanacNow, launch.now)
        .environmentObject(purchases)
    }
}
