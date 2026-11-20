import SwiftUI
import JieqiCore

struct MonthCalendarView: View {
    @Environment(\.almanacNow) private var now
    @Environment(\.colorScheme) private var scheme
    @State private var page: YearMonth?

    private var shown: YearMonth {
        page ?? YearMonth(date: Almanac.day(on: now).date)
    }

    private var monthPage: MonthPage {
        Almanac.month(year: shown.year, month: shown.month)
    }

    private var today: CivilDate {
        Almanac.day(on: now).date
    }

    var body: some View {
        let page = monthPage
        VStack(spacing: 12) {
            header
            weekdayHeader
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 6) {
                ForEach(0..<page.leadingBlanks, id: \.self) { _ in
                    Color.clear.frame(height: 58)
                }
                ForEach(page.days, id: \.date) { day in
                    dayCell(day)
                }
            }
            legend
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .background(Theme.paper(scheme))
    }

    private var header: some View {
        HStack {
            Button {
                shift(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("上个月")

            Spacer()
            VStack(spacing: 2) {
                Text("\(shown.year)年\(shown.month)月")
                    .font(.custom(Theme.serif, size: 28))
                Button("回到今天") {
                    self.page = YearMonth(date: today)
                }
                .font(.system(size: 13))
            }
            Spacer()

            Button {
                shift(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("下个月")
        }
        .foregroundStyle(Theme.ink(scheme))
    }

    private var weekdayHeader: some View {
        HStack {
            ForEach(["一", "二", "三", "四", "五", "六", "日"], id: \.self) { name in
                Text(name)
                    .font(.system(size: 12))
                    .foregroundStyle(name == "日" ? Theme.cinnabar : Theme.secondary(scheme))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayCell(_ day: DayDetail) -> some View {
        let isToday = day.date == today
        return VStack(spacing: 1) {
            Text("\(day.date.day)")
                .font(.system(size: 15, weight: isToday ? .semibold : .regular))
                .foregroundStyle(isToday ? Theme.cinnabar : Theme.ink(scheme))
            Text(day.markerText ?? " ")
                .font(.system(size: 9))
                .foregroundStyle(day.markerIsFestival ? Theme.cinnabar : Theme.ink(scheme))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(day.lunarCellText)
                .font(.system(size: 9))
                .foregroundStyle(Theme.secondary(scheme))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, minHeight: 58)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isToday ? Theme.cinnabar.opacity(0.12) : Color.clear)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText(day))
    }

    private var legend: some View {
        HStack(spacing: 16) {
            Label("节气", systemImage: "circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(Theme.ink(scheme))
            Label("节日", systemImage: "circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(Theme.cinnabar)
            Spacer()
        }
        .padding(.top, 4)
        .labelStyle(LegendLabelStyle())
    }

    private func shift(by months: Int) {
        let current = shown
        var month = current.month + months
        var year = current.year
        while month < 1 {
            month += 12
            year -= 1
        }
        while month > 12 {
            month -= 12
            year += 1
        }
        page = YearMonth(year: year, month: month)
    }

    private func accessibilityText(_ day: DayDetail) -> String {
        var text = "\(day.date.day)日 \(day.lunarLine)"
        if let marker = day.markerText {
            text += " \(marker)"
        }
        return text
    }
}

private struct YearMonth: Equatable {
    var year: Int
    var month: Int

    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }

    init(date: CivilDate) {
        year = date.year
        month = date.month
    }
}

private struct LegendLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon.font(.system(size: 6))
            configuration.title
        }
    }
}
