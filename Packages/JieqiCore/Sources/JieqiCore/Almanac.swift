import Foundation
import LunarSwift

/// 公历日期，按北京时间的年月日，不带时区换算。
public struct CivilDate: Equatable, Hashable, CustomStringConvertible {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public var description: String { "\(year)-\(month)-\(day)" }
    public var text: String { "\(year)年\(month)月\(day)日" }
    public var shortText: String { "\(month)月\(day)日" }
}

public struct SolarTermMoment: Equatable, CustomStringConvertible {
    public let term: SolarTerm
    public let date: CivilDate
    public let hour: Int
    public let minute: Int

    public var timeText: String { String(format: "%02d:%02d", hour, minute) }
    public var description: String { "\(term.name) \(date) \(timeText)" }
}

public struct DayDetail: Equatable {
    public let date: CivilDate
    /// `Calendar` 的 weekday：1 是星期日，7 是星期六。
    public let weekday: Int
    public let weekdayText: String
    public let lunarYear: Int
    /// 负数表示闰月，与 lunar-swift 一致。
    public let lunarMonth: Int
    public let lunarDay: Int
    public let lunarMonthText: String
    public let lunarDayText: String
    public let ganZhiYear: String
    public let shengXiao: String
    public let isLeapMonth: Bool
    /// 公历这一天正好是节气日时有值。按北京时间的日期，不按交节时辰拆成上下午。
    public let todayTerm: SolarTermMoment?
    /// 当前所处的节气：最近一个已经到来的节气日，包含今天。
    public let currentTerm: SolarTermMoment
    public let nextTerm: SolarTermMoment
    public let daysUntilNextTerm: Int
    public let festivals: [Festival]

    public var lunarLine: String { "\(lunarMonthText)月\(lunarDayText)" }
    public var gregorianText: String { date.text }
    public var weekdayLabel: String { "星期\(weekdayText)" }
    public var ganZhiLine: String { "\(ganZhiYear)年 · \(shengXiao)" }
    public var termTimeLine: String {
        "交节 \(currentTerm.date.shortText) \(currentTerm.timeText) 北京时间"
    }
    public var nextTermLine: String { "距\(nextTerm.term.name) \(daysUntilNextTerm) 天" }

    /// 月历格子上的农历字：初一写月名（含闰月），其余写日名。
    public var lunarCellText: String {
        if lunarDay == 1 {
            return "\(lunarMonthText)月"
        }
        return lunarDayText
    }

    /// 格子上优先标节气，其次标节日。
    public var markerText: String? {
        if let todayTerm {
            return todayTerm.term.name
        }
        return festivals.first?.shortName
    }

    public var markerIsFestival: Bool {
        todayTerm == nil && festivals.first != nil
    }

    /// 节气日仍以节气为主。没有节气的节日用节日当这一天的主图和主标题。
    public var featuredFestival: Festival? {
        guard todayTerm == nil else { return nil }
        return festivals.first
    }

    public var heroTitle: String {
        featuredFestival?.name ?? currentTerm.term.name
    }

    /// 铺在首页和小组件上的图。清明当天节气与节日是同一张。
    public var illustrationPinyin: String {
        featuredFestival?.pinyin ?? currentTerm.term.pinyin
    }
}

public struct MonthPage: Equatable {
    public let year: Int
    public let month: Int
    /// 周一列是 0。1 日之前留白的格数。
    public let leadingBlanks: Int
    public let days: [DayDetail]
}

public struct WidgetSnapshot: Equatable {
    public let yearLine: String
    public let dateLine: String
    public let weekdayLine: String
    public let lunarLine: String
    public let ganZhiLine: String
    public let primaryLabel: String
    public let primaryName: String
    public let secondaryLine: String
    public let illustrationPinyin: String
}

/// 历法门面。只做公历、农历、节气和列出的传统节日。
/// 不读取、不展示宜忌、运势、八字、佛历、道历、吉神方位。
public enum Almanac {
    public static let timeZone = TimeZone(identifier: "Asia/Shanghai")!

    private static let weekdayNames = ["", "日", "一", "二", "三", "四", "五", "六"]

    public static func date(year: Int, month: Int, day: Int, hour: Int = 12, minute: Int = 0) -> Date {
        var calendar = gregorian
        let parts = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return calendar.date(from: parts) ?? Date(timeIntervalSince1970: 0)
    }

    public static func parse(dateString: String) -> Date? {
        let parts = dateString.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return date(year: parts[0], month: parts[1], day: parts[2])
    }

    public static func day(on date: Date) -> DayDetail {
        let parts = gregorian.dateComponents([.year, .month, .day], from: date)
        return day(year: parts.year ?? 1, month: parts.month ?? 1, day: parts.day ?? 1)
    }

    public static func day(year: Int, month: Int, day: Int) -> DayDetail {
        let solar = Solar.fromYmdHms(year: year, month: month, day: day, hour: 12)
        let lunar = solar.lunar
        let current = moment(lunar.getPrevJieQi(wholeDay: true))
        let next = moment(lunar.getNextJieQi(wholeDay: true))
        let today = CivilDate(year: year, month: month, day: day)
        let todayTerm = current.date == today ? current : nil
        let weekday = weekdayIndex(year: year, month: month, day: day)
        let days = max(0, next.solarDayCount(from: today))
        return DayDetail(
            date: today,
            weekday: weekday,
            weekdayText: weekdayNames[weekday],
            lunarYear: lunar.year,
            lunarMonth: lunar.month,
            lunarDay: lunar.day,
            lunarMonthText: lunar.monthInChinese,
            lunarDayText: lunar.dayInChinese,
            ganZhiYear: lunar.yearInGanZhi,
            shengXiao: lunar.yearShengXiao,
            isLeapMonth: lunar.month < 0,
            todayTerm: todayTerm,
            currentTerm: current,
            nextTerm: next,
            daysUntilNextTerm: days,
            festivals: festivals(on: lunar)
        )
    }

    public static func month(year: Int, month: Int) -> MonthPage {
        let first = day(year: year, month: month, day: 1)
        let count = gregorian.range(
            of: .day,
            in: .month,
            for: date(year: year, month: month, day: 1)
        )?.count ?? 30
        let days = (1...count).map { day(year: year, month: month, day: $0) }
        return MonthPage(
            year: year,
            month: month,
            leadingBlanks: (first.weekday + 5) % 7,
            days: days
        )
    }

    public static func widgetSnapshot(on date: Date) -> WidgetSnapshot {
        widgetSnapshot(for: day(on: date))
    }

    public static func widgetSnapshot(for day: DayDetail) -> WidgetSnapshot {
        let primaryLabel: String
        let primaryName: String
        let secondary: String
        if let term = day.todayTerm {
            primaryLabel = "今日"
            primaryName = term.term.name
            secondary = day.nextTermLine
        } else if let festival = day.festivals.first {
            primaryLabel = "今日"
            primaryName = festival.shortName
            secondary = day.nextTermLine
        } else {
            primaryLabel = "下一节气"
            primaryName = day.nextTerm.term.name
            secondary = "\(day.nextTerm.date.shortText) \(day.nextTerm.timeText)"
        }
        return WidgetSnapshot(
            yearLine: "\(day.date.year)",
            dateLine: day.date.shortText,
            weekdayLine: day.weekdayLabel,
            lunarLine: day.lunarLine,
            ganZhiLine: day.ganZhiLine,
            primaryLabel: primaryLabel,
            primaryName: primaryName,
            secondaryLine: secondary,
            illustrationPinyin: day.illustrationPinyin
        )
    }

    /// 下一次应当刷新小组件的时刻：下一个北京时间零点。
    public static func nextRefresh(after date: Date) -> Date {
        let start = gregorian.startOfDay(for: date)
        return gregorian.date(byAdding: .day, value: 1, to: start) ?? date.addingTimeInterval(86_400)
    }

    private static var gregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        calendar.locale = Locale(identifier: "zh_CN")
        return calendar
    }

    private static func weekdayIndex(year: Int, month: Int, day: Int) -> Int {
        let date = self.date(year: year, month: month, day: day)
        return gregorian.component(.weekday, from: date)
    }

    private static func moment(_ jieQi: JieQi?) -> SolarTermMoment {
        guard let jieQi, let term = SolarTerm(rawValue: jieQi.name) else {
            preconditionFailure("节气表没有返回可用的节气")
        }
        let solar = jieQi.solar
        return SolarTermMoment(
            term: term,
            date: CivilDate(year: solar.year, month: solar.month, day: solar.day),
            hour: solar.hour,
            minute: solar.minute
        )
    }

    private static func festivals(on lunar: Lunar) -> [Festival] {
        var found: [FestivalID] = []
        if lunar.month > 0 {
            switch (lunar.month, lunar.day) {
            case (1, 1): found.append(.chunjie)
            case (1, 15): found.append(.yuanxiao)
            case (5, 5): found.append(.duanwu)
            case (7, 7): found.append(.qixi)
            case (7, 15): found.append(.zhongyuan)
            case (8, 15): found.append(.zhongqiu)
            case (9, 9): found.append(.chongyang)
            case (12, 8): found.append(.laba)
            case (12, 23): found.append(.beifangxiaonian)
            case (12, 24): found.append(.nanfangxiaonian)
            default: break
            }
        }
        let tomorrow = lunar.solar.nextDay(days: 1).lunar
        if tomorrow.month == 1 && tomorrow.day == 1 && !(lunar.month == 1 && lunar.day == 1) {
            found.append(.chuxi)
        }
        if lunar.jieQi == SolarTerm.qingming.name {
            found.append(.qingming)
        }
        let order = FestivalID.allCases
        return found
            .sorted { lhs, rhs in
                (order.firstIndex(of: lhs) ?? 0) < (order.firstIndex(of: rhs) ?? 0)
            }
            .map(Festival.init)
    }
}

private extension SolarTermMoment {
    func solarDayCount(from today: CivilDate) -> Int {
        let start = Solar.fromYmdHms(year: today.year, month: today.month, day: today.day)
        let end = Solar.fromYmdHms(year: date.year, month: date.month, day: date.day)
        return end.subtract(solar: start)
    }
}
