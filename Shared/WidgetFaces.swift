import SwiftUI
import JieqiCore

struct SmallWidgetFace: View {
    let snapshot: WidgetSnapshot
    var scheme: ColorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(snapshot.yearLine)
                .font(.system(size: 11))
                .foregroundStyle(Theme.secondary(scheme))
            Text(snapshot.dateLine)
                .font(.custom(Theme.serif, size: 22))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(snapshot.weekdayLine)
                .font(.system(size: 12))
                .foregroundStyle(Theme.secondary(scheme))
            Text(snapshot.lunarLine)
                .font(.custom(Theme.serif, size: 15))
                .padding(.top, 4)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer(minLength: 0)
            Text(snapshot.primaryLabel)
                .font(.system(size: 11))
                .foregroundStyle(Theme.secondary(scheme))
            Text(snapshot.primaryName)
                .font(.custom(Theme.serif, size: 26))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(snapshot.secondaryLine)
                .font(.system(size: 11))
                .foregroundStyle(Theme.secondary(scheme))
                .lineLimit(2)
        }
        .foregroundStyle(Theme.ink(scheme))
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct MediumWidgetFace: View {
    let snapshot: WidgetSnapshot
    var scheme: ColorScheme

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(snapshot.dateLine)
                    .font(.custom(Theme.serif, size: 26))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("\(snapshot.yearLine)  \(snapshot.weekdayLine)")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondary(scheme))
                Text(snapshot.lunarLine)
                    .font(.custom(Theme.serif, size: 18))
                    .padding(.top, 2)
                Text(snapshot.ganZhiLine)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondary(scheme))
                Spacer(minLength: 0)
                Text(snapshot.primaryLabel)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary(scheme))
                Text(snapshot.primaryName)
                    .font(.custom(Theme.serif, size: 30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(snapshot.secondaryLine)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondary(scheme))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            IllustrationImage(pinyin: snapshot.illustrationPinyin, maxPixelSize: 960)
                .frame(width: 92)
                .frame(maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .foregroundStyle(Theme.ink(scheme))
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
