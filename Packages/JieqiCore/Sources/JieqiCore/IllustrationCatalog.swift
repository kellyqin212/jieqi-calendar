import Foundation

/// 插画按文件名加载。二十四节气加 11 张独立节日图，清明与节气共用，共 35 张 JPEG。
public enum IllustrationCatalog {
    public static let placeholder = "placeholder"
    public static let directoryName = "Illustrations"
    public static let imageExtension = "jpg"

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

    /// 资源文件名（不含扩展名）。节日标识大多与文件名相同。
    /// 北方小年、南方小年的文件沿用交付名 `xiaonian_north` / `xiaonian_south`。
    public static func resourceStem(for pinyin: String) -> String {
        switch pinyin {
        case FestivalID.beifangxiaonian.pinyin:
            return "xiaonian_north"
        case FestivalID.nanfangxiaonian.pinyin:
            return "xiaonian_south"
        default:
            return pinyin
        }
    }

    public static func fileName(for pinyin: String) -> String {
        "\(resourceStem(for: pinyin)).\(imageExtension)"
    }
}
