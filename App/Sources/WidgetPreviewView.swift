import SwiftUI
import JieqiCore

struct WidgetPreviewView: View {
    @Environment(\.almanacNow) private var now
    @Environment(\.colorScheme) private var scheme

    private var snapshot: WidgetSnapshot { Almanac.widgetSnapshot(on: now) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("小组件")
                    .font(.custom(Theme.serif, size: 36))
                Text("桌面上的小、中两款都显示公历、农历和节气。今天若是节气或节日，先写当天的名字，下面仍标出下一个节气。")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.secondary(scheme))

                Text("小")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.secondary(scheme))
                SmallWidgetFace(snapshot: snapshot, scheme: scheme)
                    .frame(width: 170, height: 170)
                    .background(Theme.paper(scheme))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Theme.secondary(scheme).opacity(0.25), lineWidth: 1)
                    )

                Text("中")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.secondary(scheme))
                MediumWidgetFace(snapshot: snapshot, scheme: scheme)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(Theme.paper(scheme))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Theme.secondary(scheme).opacity(0.25), lineWidth: 1)
                    )
            }
            .padding(24)
        }
        .background(Theme.paperDeep.opacity(scheme == .dark ? 0.4 : 1))
        .foregroundStyle(Theme.ink(scheme))
    }
}
