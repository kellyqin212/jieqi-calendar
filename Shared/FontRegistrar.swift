import CoreText
import Foundation

enum FontRegistrar {
    static let fileName = "JieqiSong-Regular"

    static func register(bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: fileName, withExtension: "otf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}
