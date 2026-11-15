import Foundation

/// 二十四节气。`pinyin` 与插画文件名一致：把 `lichun.png` 放进插画目录即可替换占位图。
public enum SolarTerm: String, CaseIterable, Identifiable {
    case lichun = "立春"
    case yushui = "雨水"
    case jingzhe = "惊蛰"
    case chunfen = "春分"
    case qingming = "清明"
    case guyu = "谷雨"
    case lixia = "立夏"
    case xiaoman = "小满"
    case mangzhong = "芒种"
    case xiazhi = "夏至"
    case xiaoshu = "小暑"
    case dashu = "大暑"
    case liqiu = "立秋"
    case chushu = "处暑"
    case bailu = "白露"
    case qiufen = "秋分"
    case hanlu = "寒露"
    case shuangjiang = "霜降"
    case lidong = "立冬"
    case xiaoxue = "小雪"
    case daxue = "大雪"
    case dongzhi = "冬至"
    case xiaohan = "小寒"
    case dahan = "大寒"

    public var id: String { rawValue }
    public var name: String { rawValue }

    /// 资源文件名（不含扩展名）。与枚举 case 名相同。
    public var pinyin: String {
        switch self {
        case .lichun: return "lichun"
        case .yushui: return "yushui"
        case .jingzhe: return "jingzhe"
        case .chunfen: return "chunfen"
        case .qingming: return "qingming"
        case .guyu: return "guyu"
        case .lixia: return "lixia"
        case .xiaoman: return "xiaoman"
        case .mangzhong: return "mangzhong"
        case .xiazhi: return "xiazhi"
        case .xiaoshu: return "xiaoshu"
        case .dashu: return "dashu"
        case .liqiu: return "liqiu"
        case .chushu: return "chushu"
        case .bailu: return "bailu"
        case .qiufen: return "qiufen"
        case .hanlu: return "hanlu"
        case .shuangjiang: return "shuangjiang"
        case .lidong: return "lidong"
        case .xiaoxue: return "xiaoxue"
        case .daxue: return "daxue"
        case .dongzhi: return "dongzhi"
        case .xiaohan: return "xiaohan"
        case .dahan: return "dahan"
        }
    }

    /// 自撰的短说明，只讲物候，不讲宜忌。
    public var summary: String {
        switch self {
        case .lichun:
            return "东风解冻，白昼开始变长。农事上把这一天当作春天的起点。"
        case .yushui:
            return "降水渐渐变多，雪渐渐变少。泥土返潮，草木开始返青。"
        case .jingzhe:
            return "春雷渐起，蛰伏的虫子开始活动。桃花、杏花陆续开放。"
        case .chunfen:
            return "昼夜几乎等长。燕子往北飞来，春耕进入忙的时候。"
        case .qingming:
            return "气清景明，草木已经长深。这一天既是节气，也是踏青与祭扫的传统节日。"
        case .guyu:
            return "雨水够用，谷物可以下种生长。牡丹开放，春茶也到了采摘的时候。"
        case .lixia:
            return "夏天从这里算起。蛙声变密，地里的作物进入旺长。"
        case .xiaoman:
            return "籽粒开始饱满，但还没有成熟。江河的水量也渐渐上来。"
        case .mangzhong:
            return "有芒的作物要收，晚茬也要赶着种。梅雨常常落在这一段。"
        case .xiazhi:
            return "这一天白昼最长。暑热还要继续积着，荷花开了，蝉也叫得密了。"
        case .xiaoshu:
            return "天已经热，却还没到最热。人们开始找阴凉、避开正午。"
        case .dashu:
            return "一年里最热的一段。雷阵雨多，草木长得最盛。"
        case .liqiu:
            return "秋天的起点。暑气还没散完，只是早晨开始有一点凉。"
        case .chushu:
            return "暑气渐渐停住。早稻成熟，天色变得高一些、爽一些。"
        case .bailu:
            return "夜里的水汽会凝成露。天气转凉，候鸟开始往南飞。"
        case .qiufen:
            return "昼夜再次差不多一样长。此后夜比昼长，秋收展开。"
        case .hanlu:
            return "露水更凉。大雁南飞，菊花开始开放。"
        case .shuangjiang:
            return "清晨可以见到初霜。草木由绿转黄，农事转向收藏。"
        case .lidong:
            return "冬天从这里算起。水开始结冰，田里转入修整和收藏。"
        case .xiaoxue:
            return "开始下雪，雪通常还不大。天气阴冷，家里忙着腌菜、储藏。"
        case .daxue:
            return "雪量增多。河面渐渐封冻，草木大都进入休眠。"
        case .dongzhi:
            return "这一天白昼最短。古人把冬至看得很重，此后白昼会一天天变长。"
        case .xiaohan:
            return "天气已经很冷，还没到最冷。南方的早梅陆续开放。"
        case .dahan:
            return "一年里最冷的一段。冰厚土硬，离下一次立春已经不远。"
        }
    }
}
