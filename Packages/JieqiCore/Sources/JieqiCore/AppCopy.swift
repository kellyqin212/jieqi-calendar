import Foundation

/// 界面上要固定出现的说明。态度、人工智能标识和许可致谢集中在这里，避免各页各写一句。
public enum AppCopy {
    public static let stance = "本应用提供农历、节气和传统节日说明，不做宜忌、运势和吉凶判断。"
    public static let aiNotice = "本应用中的节气插画为人工智能生成合成内容。"
    public static let aiMark = "插画为人工智能生成"
    public static let timeNote = "交节时刻为北京时间，用来阅读物候，不是择日依据。"
    public static let offline = "历法、节气和节日都在本机计算，不需要登录，也不索取定位。"
    public static let fontAttribution = "节气名称使用思源宋体（Source Han Serif CN，与 Noto Serif CJK 为同一套字体），许可为 SIL Open Font License 1.1。嵌入的是按常用汉字裁出的子集。OFL 将 Source 列为保留名称，所以子集在程序里的字体名是 Jieqi Song。许可全文随应用附带，字体不单独出售。"
    public static let libraryAttribution = "农历与节气换算使用 lunar-swift 1.1.9（MIT，Copyright (c) 2023 6tail）。本应用只调用公历、农历、节气和传统节日，不调用宜忌、八字、佛历、道历或吉神方位。"
    public static let purchaseNote = "免费版可以看全部农历、节气和节日。25 元买断只解锁第二套插画和进阶小组件，这一版先接好购买层，第二套图还没有画。"
}
