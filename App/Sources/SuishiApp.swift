import SwiftUI
import JieqiCore

private struct AlmanacNowKey: EnvironmentKey {
    static let defaultValue = Date()
}

extension EnvironmentValues {
    var almanacNow: Date {
        get { self[AlmanacNowKey.self] }
        set { self[AlmanacNowKey.self] = newValue }
    }
}

struct LaunchConfiguration {
    enum Screen: String {
        case home
        case term
        case festival
        case month
        case about
        case widgets
    }

    var screenshot: Screen?
    var now: Date

    static func load() -> LaunchConfiguration {
        let arguments = ProcessInfo.processInfo.arguments
        let screen = value(after: "-screenshot", in: arguments).flatMap(Screen.init(rawValue:))
        let now = value(after: "-fixed-date", in: arguments).flatMap(Almanac.parse(dateString:)) ?? Date()
        return LaunchConfiguration(screenshot: screen, now: now)
    }

    private static func value(after flag: String, in arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: flag), index + 1 < arguments.count else { return nil }
        return arguments[index + 1]
    }
}

@main
struct SuishiApp: App {
    private let launch = LaunchConfiguration.load()

    init() {
        FontRegistrar.register()
    }

    var body: some Scene {
        WindowGroup {
            RootView(launch: launch)
        }
    }
}
