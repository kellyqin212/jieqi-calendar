import XCTest
import JieqiCore

final class AlmanacTests: XCTestCase {
    func testXiaZhi2026IsLunarFifthMonthSeventhDay() {
        let day = Almanac.day(year: 2026, month: 6, day: 21)
        XCTAssertEqual(day.todayTerm?.term, .xiazhi)
        XCTAssertEqual(day.currentTerm.term, .xiazhi)
        XCTAssertEqual(day.lunarMonth, 5)
        XCTAssertEqual(day.lunarDay, 7)
        XCTAssertEqual(day.lunarLine, "五月初七")
        XCTAssertEqual(day.ganZhiYear, "丙午")
        XCTAssertEqual(day.shengXiao, "马")
        XCTAssertEqual(day.weekdayText, "日")
        XCTAssertEqual(day.nextTerm.term, .xiaoshu)
        XCTAssertEqual(day.nextTerm.date, CivilDate(year: 2026, month: 7, day: 7))
        XCTAssertEqual(day.daysUntilNextTerm, 16)
        assertTime(day.currentTerm, hour: 16, minute: 25)
    }

    func testDayBeforeXiaZhiPointsAtTheComingTerm() {
        let day = Almanac.day(year: 2026, month: 6, day: 20)
        XCTAssertNil(day.todayTerm)
        XCTAssertEqual(day.currentTerm.term, .mangzhong)
        XCTAssertEqual(day.currentTerm.date, CivilDate(year: 2026, month: 6, day: 5))
        XCTAssertEqual(day.nextTerm.term, .xiazhi)
        XCTAssertEqual(day.nextTerm.date, CivilDate(year: 2026, month: 6, day: 21))
        XCTAssertEqual(day.daysUntilNextTerm, 1)
        XCTAssertNil(day.featuredFestival)
        XCTAssertEqual(day.heroTitle, "芒种")
        XCTAssertEqual(day.illustrationPinyin, "mangzhong")
    }

    func testLiChun2026IsStillThePreviousLunarYear() {
        let day = Almanac.day(year: 2026, month: 2, day: 4)
        XCTAssertEqual(day.todayTerm?.term, .lichun)
        XCTAssertEqual(day.lunarYear, 2025)
        XCTAssertEqual(day.lunarMonth, 12)
        XCTAssertEqual(day.lunarDay, 17)
        XCTAssertEqual(day.lunarLine, "腊月十七")
        XCTAssertEqual(day.ganZhiYear, "乙巳")
        XCTAssertEqual(day.shengXiao, "蛇")
        assertTime(day.currentTerm, hour: 4, minute: 2)
    }

    func testChunFenAndQingMing2026() {
        let chunfen = Almanac.day(year: 2026, month: 3, day: 20)
        XCTAssertEqual(chunfen.todayTerm?.term, .chunfen)
        XCTAssertEqual(chunfen.lunarLine, "二月初二")
        assertTime(chunfen.currentTerm, hour: 22, minute: 46)

        let qingming = Almanac.day(year: 2026, month: 4, day: 5)
        XCTAssertEqual(qingming.todayTerm?.term, .qingming)
        XCTAssertTrue(qingming.festivals.contains { $0.id == .qingming })
        XCTAssertEqual(qingming.lunarLine, "二月十八")
        XCTAssertNil(qingming.featuredFestival)
        XCTAssertEqual(qingming.heroTitle, "清明")
        XCTAssertEqual(qingming.illustrationPinyin, "qingming")
    }

    func testDongZhi2026AndTheFollowingXiaoHan() {
        let day = Almanac.day(year: 2026, month: 12, day: 22)
        XCTAssertEqual(day.todayTerm?.term, .dongzhi)
        XCTAssertEqual(day.lunarMonth, 11)
        XCTAssertEqual(day.lunarDay, 14)
        XCTAssertEqual(day.lunarLine, "冬月十四")
        XCTAssertEqual(day.nextTerm.term, .xiaohan)
        XCTAssertEqual(day.nextTerm.date, CivilDate(year: 2027, month: 1, day: 5))
        assertTime(day.currentTerm, hour: 4, minute: 50)
    }

    func testXiaoHan2026FallsBeforeSpringFestival() {
        let day = Almanac.day(year: 2026, month: 1, day: 5)
        XCTAssertEqual(day.todayTerm?.term, .xiaohan)
        XCTAssertEqual(day.lunarYear, 2025)
        XCTAssertEqual(day.lunarMonth, 11)
        XCTAssertEqual(day.lunarDay, 17)
        XCTAssertEqual(day.ganZhiYear, "乙巳")
    }

    func testSpringFestivalsAndNewYearEve() {
        let newYear2024 = Almanac.day(year: 2024, month: 2, day: 10)
        XCTAssertEqual(newYear2024.lunarLine, "正月初一")
        XCTAssertEqual(newYear2024.festivals.map(\.id), [.chunjie])
        XCTAssertEqual(newYear2024.ganZhiYear, "甲辰")
        XCTAssertEqual(newYear2024.shengXiao, "龙")

        let newYear2025 = Almanac.day(year: 2025, month: 1, day: 29)
        XCTAssertEqual(newYear2025.lunarLine, "正月初一")
        XCTAssertEqual(newYear2025.festivals.map(\.id), [.chunjie])
        XCTAssertEqual(newYear2025.ganZhiYear, "乙巳")
        XCTAssertEqual(newYear2025.shengXiao, "蛇")

        let newYear2026 = Almanac.day(year: 2026, month: 2, day: 17)
        XCTAssertEqual(newYear2026.lunarLine, "正月初一")
        XCTAssertEqual(newYear2026.festivals.map(\.id), [.chunjie])

        let eve = Almanac.day(year: 2026, month: 2, day: 16)
        XCTAssertEqual(eve.festivals.map(\.id), [.chuxi])
        XCTAssertEqual(eve.lunarMonth, 12)
        XCTAssertFalse(eve.festivals.contains { $0.id == .chunjie })
        XCTAssertEqual(eve.featuredFestival?.id, .chuxi as FestivalID?)
        XCTAssertEqual(eve.heroTitle, "除夕")
        XCTAssertEqual(eve.illustrationPinyin, "chuxi")

        let chunjie = Almanac.day(year: 2026, month: 2, day: 17)
        XCTAssertEqual(chunjie.featuredFestival?.id, .chunjie as FestivalID?)
        XCTAssertEqual(chunjie.heroTitle, "春节")
        XCTAssertEqual(chunjie.illustrationPinyin, "chunjie")
        let chunjieWidget = Almanac.widgetSnapshot(for: chunjie)
        XCTAssertEqual(chunjieWidget.primaryName, "春节")
        XCTAssertEqual(chunjieWidget.illustrationPinyin, "chunjie")
    }

    func testDuanWuAndYuanXiao2026() {
        let duanwu = Almanac.day(year: 2026, month: 6, day: 19)
        XCTAssertEqual(duanwu.lunarLine, "五月初五")
        XCTAssertEqual(duanwu.festivals.map(\.id), [.duanwu])
        XCTAssertEqual(duanwu.heroTitle, "端午")
        XCTAssertEqual(duanwu.illustrationPinyin, "duanwu")
        XCTAssertEqual(Almanac.widgetSnapshot(for: duanwu).illustrationPinyin, "duanwu")

        let yuanxiao = Almanac.day(year: 2026, month: 3, day: 3)
        XCTAssertEqual(yuanxiao.lunarLine, "正月十五")
        XCTAssertEqual(yuanxiao.festivals.map(\.id), [.yuanxiao])
    }

    func testLeapSixthMonth2025DoesNotRepeatFestivals() {
        let leap = Almanac.day(year: 2025, month: 7, day: 25)
        XCTAssertTrue(leap.isLeapMonth)
        XCTAssertEqual(leap.lunarMonth, -6)
        XCTAssertEqual(leap.lunarDay, 1)
        XCTAssertEqual(leap.lunarLine, "闰六月初一")
        XCTAssertEqual(leap.lunarCellText, "闰六月")
        XCTAssertTrue(leap.festivals.isEmpty)

        let regular = Almanac.day(year: 2025, month: 6, day: 25)
        XCTAssertFalse(regular.isLeapMonth)
        XCTAssertEqual(regular.lunarMonth, 6)
        XCTAssertEqual(regular.lunarLine, "六月初一")
    }

    func testZhongQiu2026LandsOnLunarEighthMonthFifteenth() {
        let days = Almanac.month(year: 2026, month: 9).days + Almanac.month(year: 2026, month: 10).days
        let match = days.filter { $0.festivals.contains { $0.id == .zhongqiu } }
        XCTAssertEqual(match.count, 1)
        XCTAssertEqual(match.first?.lunarMonth, 8)
        XCTAssertEqual(match.first?.lunarDay, 15)
    }

    func testNovember2026IsBetweenLiDongAndXiaoXue() {
        let day = Almanac.day(year: 2026, month: 11, day: 15)
        XCTAssertNil(day.todayTerm)
        XCTAssertEqual(day.currentTerm.term, .lidong)
        XCTAssertEqual(day.currentTerm.date, CivilDate(year: 2026, month: 11, day: 7))
        XCTAssertEqual(day.nextTerm.term, .xiaoxue)
        XCTAssertEqual(day.nextTerm.date, CivilDate(year: 2026, month: 11, day: 22))
        XCTAssertEqual(day.daysUntilNextTerm, 7)
    }

    func testJune2026MonthStartsOnMondayAndMarksTerms() {
        let page = Almanac.month(year: 2026, month: 6)
        XCTAssertEqual(page.leadingBlanks, 0)
        XCTAssertEqual(page.days.count, 30)
        XCTAssertEqual(page.days[20].date.day, 21)
        XCTAssertEqual(page.days[20].markerText, "夏至")
        XCTAssertEqual(page.days[18].markerText, "端午")
        XCTAssertEqual(page.days[18].markerIsFestival, true)
    }

    func testWidgetSnapshotShowsTodayTermAndTheFollowingOne() {
        let onTerm = Almanac.widgetSnapshot(on: Almanac.date(year: 2026, month: 6, day: 21))
        XCTAssertEqual(onTerm.primaryLabel, "今日")
        XCTAssertEqual(onTerm.primaryName, "夏至")
        XCTAssertEqual(onTerm.lunarLine, "五月初七")
        XCTAssertTrue(onTerm.secondaryLine.contains("小暑"))
        XCTAssertEqual(onTerm.illustrationPinyin, "xiazhi")

        let before = Almanac.widgetSnapshot(on: Almanac.date(year: 2026, month: 6, day: 20))
        XCTAssertEqual(before.primaryLabel, "下一节气")
        XCTAssertEqual(before.primaryName, "夏至")
        XCTAssertEqual(before.illustrationPinyin, "mangzhong")
        XCTAssertTrue(before.secondaryLine.contains("16:"))
    }

    func testIllustrationNamesCoverThirtyFiveDropInFiles() {
        let names = IllustrationCatalog.orderedPinyin
        XCTAssertEqual(names.count, 35)
        XCTAssertEqual(names.first, "lichun")
        XCTAssertTrue(names.contains("xiazhi"))
        XCTAssertTrue(names.contains("dongzhi"))
        XCTAssertTrue(names.contains("qingming"))
        XCTAssertEqual(names.filter { $0 == "qingming" }.count, 1)
        XCTAssertTrue(names.contains("beifangxiaonian"))
        XCTAssertTrue(names.contains("nanfangxiaonian"))
        XCTAssertEqual(Set(names).count, names.count)
        XCTAssertEqual(IllustrationCatalog.fileName(for: "beifangxiaonian"), "xiaonian_north.jpg")
        XCTAssertEqual(IllustrationCatalog.fileName(for: "nanfangxiaonian"), "xiaonian_south.jpg")
        XCTAssertEqual(IllustrationCatalog.fileName(for: "qingming"), "qingming.jpg")
        var stems = Set<String>()
        for name in names {
            XCTAssertNotNil(name.range(of: "^[a-z]+$", options: .regularExpression))
            let stem = IllustrationCatalog.resourceStem(for: name)
            XCTAssertTrue(stems.insert(stem).inserted, stem)
            XCTAssertEqual(IllustrationCatalog.fileName(for: name), "\(stem).jpg")
        }
        XCTAssertEqual(stems.count, 35)
        XCTAssertTrue(stems.contains("xiaonian_north"))
        XCTAssertTrue(stems.contains("xiaonian_south"))
        XCTAssertEqual(SolarTerm.allCases.map(\.pinyin).count, 24)
        XCTAssertEqual(FestivalID.allCases.count, 12)
    }

    func testAppAndWidgetShipEveryIllustration() throws {
        let app = Bundle(identifier: "app.suishi.calendar") ?? Bundle.main
        XCTAssertEqual(app.bundleIdentifier ?? "", "app.suishi.calendar", "bundle \(app.bundlePath)")
        for pinyin in IllustrationCatalog.orderedPinyin {
            let stem = IllustrationCatalog.resourceStem(for: pinyin)
            let url = app.url(
                forResource: stem,
                withExtension: IllustrationCatalog.imageExtension,
                subdirectory: IllustrationCatalog.directoryName
            ) ?? app.url(forResource: stem, withExtension: IllustrationCatalog.imageExtension)
            XCTAssertNotNil(url, "missing \(stem).jpg in \(app.bundlePath)")
        }

        let appex = try XCTUnwrap(
            app.builtInPlugInsURL?.appendingPathComponent("SuishiWidget.appex"),
            "widget appex"
        )
        let widget = try XCTUnwrap(Bundle(url: appex))
        var appBytes = 0
        var widgetBytes = 0
        for pinyin in IllustrationCatalog.orderedPinyin {
            let stem = IllustrationCatalog.resourceStem(for: pinyin)
            let appURL = try XCTUnwrap(
                app.url(forResource: stem, withExtension: "jpg", subdirectory: IllustrationCatalog.directoryName),
                stem
            )
            let widgetURL = try XCTUnwrap(
                widget.url(forResource: stem, withExtension: "jpg", subdirectory: IllustrationCatalog.directoryName),
                "widget \(stem)"
            )
            let appSize = try fileSize(appURL)
            let widgetSize = try fileSize(widgetURL)
            appBytes += appSize
            widgetBytes += widgetSize
            XCTAssertGreaterThan(widgetSize, 8_000, stem)
            XCTAssertLessThan(widgetSize, appSize, "\(stem) should be the downsampled widget plate")
        }
        XCTAssertLessThan(widgetBytes, appBytes)
    }

    private func fileSize(_ url: URL) throws -> Int {
        let values = try url.resourceValues(forKeys: [.fileSizeKey])
        return try XCTUnwrap(values.fileSize)
    }

    func testPhenologyAndFestivalNotesStayOffFortuneContent() {
        let banned = ["宜忌", "运势", "吉凶", "八字", "财神", "喜神", "黄历", "择吉", "冲煞", "彭祖", "佛历", "道历"]
        let corpus = SolarTerm.allCases.map(\.summary) + FestivalID.allCases.map(\.note)
        XCTAssertEqual(corpus.count, 36)
        for text in corpus {
            XCTAssertGreaterThan(text.count, 12)
            for word in banned {
                XCTAssertFalse(text.contains(word), "\(word) in \(text)")
            }
        }
    }

    func testNoticesNameTheRefusalsAndTheLicenses() {
        XCTAssertTrue(AppCopy.stance.contains("不做宜忌、运势和吉凶判断"))
        XCTAssertTrue(AppCopy.aiNotice.contains("人工智能生成"))
        XCTAssertTrue(AppCopy.fontAttribution.contains("Open Font License"))
        XCTAssertTrue(AppCopy.fontAttribution.contains("Jieqi Song"))
        XCTAssertTrue(AppCopy.libraryAttribution.contains("MIT"))
        XCTAssertTrue(AppCopy.libraryAttribution.contains("6tail"))
        XCTAssertEqual(PremiumTheme.productID, "app.suishi.theme.premium")
        XCTAssertEqual(PremiumTheme.priceCNY, 25)
    }

    private func assertTime(
        _ moment: SolarTermMoment,
        hour: Int,
        minute: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(moment.hour, hour, "hour of \(moment)", file: file, line: line)
        XCTAssertLessThanOrEqual(abs(moment.minute - minute), 2, "minute of \(moment)", file: file, line: line)
    }
}
