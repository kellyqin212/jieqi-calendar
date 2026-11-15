import SwiftUI
import JieqiCore

struct HomeView: View {
    @Environment(\.almanacNow) private var now
    @State private var showDetail = false

    private var day: DayDetail { Almanac.day(on: now) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            IllustrationImage(pinyin: day.currentTerm.term.pinyin)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Theme.paperLight.opacity(0.72),
                    Theme.paperLight.opacity(0.28),
                    Theme.paperLight.opacity(0),
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 6) {
                Text("岁时")
                    .font(.custom(Theme.serif, size: 18))
                if IllustrationStore.hasDedicatedImage(day.currentTerm.term.pinyin) {
                    Text(AppCopy.aiMark)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.inkSoft)
                }
                Text(day.gregorianText)
                    .font(.custom(Theme.serif, size: 30))
                    .padding(.top, 10)
                Text(day.weekdayLabel)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.inkSoft)
                Text(day.lunarLine)
                    .font(.custom(Theme.serif, size: 22))
                    .padding(.top, 4)
                Text(day.ganZhiLine)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSoft)

                Button {
                    showDetail = true
                } label: {
                    Text(day.currentTerm.term.name)
                        .font(.custom(Theme.serif, size: 84))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 18)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(day.currentTerm.term.name)

                Text(day.termTimeLine)
                    .font(.system(size: 14))
                Text(day.nextTermLine)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSoft)
                if let festival = day.festivals.first, day.todayTerm == nil {
                    Text("今日\(festival.name)")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.cinnabar)
                }
                Text(day.currentTerm.term.summary)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSoft)
                    .lineLimit(3)
                    .padding(.top, 6)
                Spacer(minLength: 0)
            }
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 28)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $showDetail) {
            TermDetailSheet(moment: day.currentTerm, festivals: day.festivals)
                .presentationDetents([.medium, .large])
        }
    }
}

struct TermDetailSheet: View {
    let moment: SolarTermMoment
    let festivals: [Festival]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(moment.term.name)
                    .font(.custom(Theme.serif, size: 48))
                Text("交节 \(moment.date.text) \(moment.timeText)")
                    .font(.system(size: 17))
                Text(AppCopy.timeNote)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSoft)
                Text(moment.term.summary)
                    .font(.system(size: 17))
                    .fixedSize(horizontal: false, vertical: true)
                if moment.term == .qingming || festivals.contains(where: { $0.id == .qingming }) {
                    Text(FestivalID.qingming.note)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.inkSoft)
                }
            }
            .foregroundStyle(Theme.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .background(Theme.paperLight)
    }
}
