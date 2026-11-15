import Foundation

/// 插画按拼音文件名加载。二十四节气加 11 张独立节日图，清明与节气共用，共 35 个名字。
public enum IllustrationCatalog {
    public static let placeholder = "placeholder"
    public static let directoryName = "Illustrations"

    /// 稳定顺序：先 24 个节气（自立春起），再节日里还没出现过的拼音。
    public static var orderedPinyin: [String] {
        var seen = Set<String>()
        var names: [String] = []
        for name in SolarTerm.allCases.map(\.pinyin) + FestivalID.allCases.map(\.pinyin) {
            if seen.insert(name).inserted {
                names.append(name)
            }
        }
        return names
    }

    public static func fileName(for pinyin: String) -> String {
        "\(pinyin).png"
    }
}
