import SwiftUI

enum Theme {
    static let serif = "JieqiSong-Regular"
    static let ink = Color(red: 0.165, green: 0.125, blue: 0.078)
    static let inkSoft = Color(red: 0.42, green: 0.345, blue: 0.275)
    static let cinnabar = Color(red: 0.62, green: 0.23, blue: 0.16)
    static let paperLight = Color(red: 0.953, green: 0.910, blue: 0.835)
    static let paperDeep = Color(red: 0.91, green: 0.84, blue: 0.74)

    static func ink(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(red: 0.96, green: 0.92, blue: 0.86) : ink
    }

    static func secondary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(red: 0.76, green: 0.70, blue: 0.62) : inkSoft
    }

    static func paper(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(red: 0.11, green: 0.10, blue: 0.09) : paperLight
    }

    static func card(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(red: 0.16, green: 0.15, blue: 0.13) : Color.white.opacity(0.45)
    }
}
