import WidgetKit
import SwiftUI
import JieqiCore

struct SuishiEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
}

struct SuishiProvider: TimelineProvider {
    func placeholder(in context: Context) -> SuishiEntry {
        entry(on: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SuishiEntry) -> Void) {
        completion(entry(on: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SuishiEntry>) -> Void) {
        let now = Date()
        let timeline = Timeline(entries: [entry(on: now)], policy: .after(Almanac.nextRefresh(after: now)))
        completion(timeline)
    }

    private func entry(on date: Date) -> SuishiEntry {
        SuishiEntry(date: date, snapshot: Almanac.widgetSnapshot(on: date))
    }
}

struct SuishiWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme
    let entry: SuishiEntry

    var body: some View {
        Group {
            if family == .systemMedium {
                MediumWidgetFace(snapshot: entry.snapshot, scheme: scheme)
            } else {
                SmallWidgetFace(snapshot: entry.snapshot, scheme: scheme)
            }
        }
        .containerBackground(for: .widget) {
            Theme.paper(scheme)
        }
    }
}

struct SuishiWidget: Widget {
    let kind = "app.suishi.calendar.term"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SuishiProvider()) { entry in
            SuishiWidgetView(entry: entry)
        }
        .configurationDisplayName("岁时")
        .description("公历、农历和节气。没有宜忌，也没有广告。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct SuishiWidgetBundle: WidgetBundle {
    init() {
        FontRegistrar.register()
    }

    var body: some Widget {
        SuishiWidget()
    }
}
