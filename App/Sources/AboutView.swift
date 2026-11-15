import SwiftUI
import JieqiCore

struct AboutView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var purchases: PurchaseManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("关于")
                        .font(.custom(Theme.serif, size: 40))

                    Text(AppCopy.stance)
                        .font(.custom(Theme.serif, size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.card(scheme))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    section(title: "人工智能生成合成内容") {
                        Text(AppCopy.aiNotice)
                        Text("成稿目前有立春、夏至、冬至三张，图中没有字。其余节气和节日仍是一张素纸占位，那张占位图不是生成插画。")
                            .foregroundStyle(Theme.secondary(scheme))
                    }

                    section(title: "字体") {
                        Text(AppCopy.fontAttribution)
                        NavigationLink("查看字体许可全文") {
                            LicenseTextView(title: "思源宋体许可", resource: "OFL-SourceHanSerif")
                        }
                    }

                    section(title: "历法库") {
                        Text(AppCopy.libraryAttribution)
                        NavigationLink("查看 lunar-swift 许可全文") {
                            LicenseTextView(title: "lunar-swift 许可", resource: "LunarSwift-MIT")
                        }
                    }

                    section(title: "数据") {
                        Text(AppCopy.offline)
                        Text(AppCopy.timeNote)
                        Text("法定节假日和调休还没有放进这一版。")
                            .foregroundStyle(Theme.secondary(scheme))
                    }

                    section(title: "第二套主题") {
                        Text(AppCopy.purchaseNote)
                        Text(purchases.message)
                        if purchases.isUnlocked {
                            Text("此设备的测试环境已解锁。正式插画尚未替换。")
                                .foregroundStyle(Theme.cinnabar)
                        }
                        Button(purchases.isUnlocked ? "已解锁（测试）" : "用本地配置购买") {
                            Task { await purchases.purchase() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.cinnabar)
                        .disabled(purchases.product == nil || purchases.isUnlocked)
                    }

                    Text("版本 \(version)")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondary(scheme))
                }
                .font(.system(size: 15))
                .foregroundStyle(Theme.ink(scheme))
                .padding(24)
            }
            .background(Theme.paper(scheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { purchases.startIfNeeded() }
        }
    }

    private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom(Theme.serif, size: 22))
            content()
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.1.0"
    }
}

struct LicenseTextView: View {
    let title: String
    let resource: String
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            Text(load())
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(Theme.ink(scheme))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .textSelection(.enabled)
        }
        .background(Theme.paper(scheme))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func load() -> String {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            return "没有找到许可文本。"
        }
        return text
    }
}
