import SwiftUI
import JieqiCore

struct HomeView: View {
    @Environment(\.almanacNow) private var now
    @State private var showDetail = false

    private var day: DayDetail { Almanac.day(on: now) }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("岁时")
                .font(.custom(Theme.serif, size: 18))
            if IllustrationStore.hasDedicatedImage(day.illustrationPinyin) {
                Text(AppCopy.aiMark)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.inkSoft)
            }
            Text(day.gregorianText)
                .font(.custom(Theme.serif, size: 30))
                .padding(.top, 8)
            Text(day.weekdayLabel)
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSoft)
            Text(day.lunarLine)
                .font(.custom(Theme.serif, size: 22))
                .padding(.top, 2)
            Text(day.ganZhiLine)
                .font(.system(size: 14))
                .foregroundStyle(Theme.inkSoft)

            if day.featuredFestival != nil {
                Text("节日")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.cinnabar)
                    .padding(.top, 12)
            }
            Button {
                showDetail = true
            } label: {
                Text(day.heroTitle)
                    .font(.custom(Theme.serif, size: 72))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.top, day.featuredFestival == nil ? 12 : 0)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(day.heroTitle)

            Text(day.termTimeLine)
                .font(.system(size: 14))
            Text(day.nextTermLine)
                .font(.system(size: 14))
                .foregroundStyle(Theme.inkSoft)
            if day.featuredFestival != nil {
                Text("节气 \(day.currentTerm.term.name)")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSoft)
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(Theme.ink)
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                ZStack(alignment: .top) {
                    IllustrationImage(pinyin: day.illustrationPinyin)
                        .frame(width: width, height: height)
                        .clipped()
                    LinearGradient(
                        stops: [
                            .init(color: Theme.paperLight.opacity(0.94), location: 0),
                            .init(color: Theme.paperLight.opacity(0.88), location: 0.38),
                            .init(color: Theme.paperLight.opacity(0.5), location: 0.7),
                            .init(color: Theme.paperLight.opacity(0), location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: width, height: height * 0.72)
                }
                .frame(width: width, height: height)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
        .sheet(isPresented: $showDetail) {
            TermDetailSheet(
                moment: day.currentTerm,
                festivals: day.festivals,
                featuredFestival: day.featuredFestival
            )
            .presentationDetents([.medium, .large])
        }
    }
}

struct TermDetailScreen: View {
    @Environment(\.almanacNow) private var now

    private var day: DayDetail { Almanac.day(on: now) }

    var body: some View {
        TermDetailContent(
            moment: day.currentTerm,
            festivals: day.festivals,
            featuredFestival: day.featuredFestival
        )
    }
}

struct TermDetailSheet: View {
    let moment: SolarTermMoment
    let festivals: [Festival]
    var featuredFestival: Festival?

    var body: some View {
        TermDetailContent(
            moment: moment,
            festivals: festivals,
            featuredFestival: featuredFestival
        )
    }
}

struct TermDetailContent: View {
    let moment: SolarTermMoment
    let festivals: [Festival]
    var featuredFestival: Festival?

    private var platePinyin: String {
        featuredFestival?.pinyin ?? moment.term.pinyin
    }

    private var plateTitle: String {
        featuredFestival?.name ?? moment.term.name
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    IllustrationImage(pinyin: platePinyin)
                        .frame(height: 400)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    LinearGradient(
                        colors: [
                            Theme.paperLight.opacity(0),
                            Theme.paperLight.opacity(0.15),
                            Theme.paperLight,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 150)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .allowsHitTesting(false)
                    VStack(alignment: .leading, spacing: 4) {
                        if featuredFestival != nil {
                            Text("节日")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.cinnabar)
                        }
                        Text(plateTitle)
                            .font(.custom(Theme.serif, size: 52))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                }

                VStack(alignment: .leading, spacing: 14) {
                    if let festival = featuredFestival {
                        Text(festival.note)
                            .font(.system(size: 17))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("当日节气 \(moment.term.name)")
                            .font(.custom(Theme.serif, size: 22))
                            .padding(.top, 6)
                    }
                    Text("交节 \(moment.date.text) \(moment.timeText)")
                        .font(.system(size: 17))
                    Text(AppCopy.timeNote)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.inkSoft)
                    Text(moment.term.summary)
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true)
                    if featuredFestival == nil {
                        ForEach(festivals) { festival in
                            Text(festival.name)
                                .font(.custom(Theme.serif, size: 22))
                                .padding(.top, 8)
                            Text(festival.note)
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(24)
            }
        }
        .background(Theme.paperLight)
        .foregroundStyle(Theme.ink)
    }
}
