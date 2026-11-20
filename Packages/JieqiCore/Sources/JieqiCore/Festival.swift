import Foundation

/// 首批传统节日。清明与节气共用 `qingming` 这张插画，所以不另占一个文件名。
public enum FestivalID: String, CaseIterable, Identifiable {
    case chunjie
    case chuxi
    case yuanxiao
    case qingming
    case duanwu
    case qixi
    case zhongyuan
    case zhongqiu
    case chongyang
    case laba
    case beifangxiaonian
    case nanfangxiaonian

    public var id: String { rawValue }
    public var pinyin: String { rawValue }

    public var name: String {
        switch self {
        case .chunjie: return "春节"
        case .chuxi: return "除夕"
        case .yuanxiao: return "元宵"
        case .qingming: return "清明"
        case .duanwu: return "端午"
        case .qixi: return "七夕"
        case .zhongyuan: return "中元"
        case .zhongqiu: return "中秋"
        case .chongyang: return "重阳"
        case .laba: return "腊八"
        case .beifangxiaonian: return "北方小年"
        case .nanfangxiaonian: return "南方小年"
        }
    }

    /// 月历格子里用的短名。
    public var shortName: String {
        switch self {
        case .beifangxiaonian: return "北小年"
        case .nanfangxiaonian: return "南小年"
        default: return name
        }
    }

    public var note: String {
        switch self {
        case .chunjie:
            return "农历正月初一，是一年的开始，也是家人团聚之后的第一天。"
        case .chuxi:
            return "农历一年的最后一天。家里通常会聚在一起吃饭、守岁。"
        case .yuanxiao:
            return "正月十五。街上赏花灯，家里吃元宵。"
        case .qingming:
            return "既是节气，也是踏青、祭扫的传统节日。插画与清明节气共用一张。"
        case .duanwu:
            return "五月初五。吃粽子、赛龙舟的习俗流传很广，纪念屈原是其中一种说法。"
        case .qixi:
            return "七月初七，对应牛郎织女的传说。旧时有向织女星乞巧的习俗。"
        case .zhongyuan:
            return "七月十五。民间在这一天祭祖、放河灯。这里只说明习俗，不提供祭祀或超度功能。"
        case .zhongqiu:
            return "八月十五。赏月、吃月饼，是家人团聚的日子。"
        case .chongyang:
            return "九月初九。登高、赏菊，是秋天的一个传统日子。"
        case .laba:
            return "腊月初八。喝腊八粥，用来标记年节将近。"
        case .beifangxiaonian:
            return "腊月二十三。北方多在这一天扫尘，并送灶王。"
        case .nanfangxiaonian:
            return "腊月二十四。南方多把这一天当作小年。"
        }
    }
}

public struct Festival: Equatable, Identifiable {
    public let id: FestivalID

    public init(_ id: FestivalID) {
        self.id = id
    }

    public var name: String { id.name }
    public var shortName: String { id.shortName }
    public var pinyin: String { id.pinyin }
    public var note: String { id.note }
}
