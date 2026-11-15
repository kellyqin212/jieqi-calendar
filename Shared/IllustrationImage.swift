import SwiftUI
import UIKit
import JieqiCore

enum IllustrationStore {
    static func dedicatedURL(for pinyin: String, bundle: Bundle = .main) -> URL? {
        locate(pinyin, bundle: bundle)
    }

    static func hasDedicatedImage(_ pinyin: String, bundle: Bundle = .main) -> Bool {
        dedicatedURL(for: pinyin, bundle: bundle) != nil
    }

    static func image(for pinyin: String, bundle: Bundle = .main) -> UIImage? {
        let url = locate(pinyin, bundle: bundle) ?? locate(IllustrationCatalog.placeholder, bundle: bundle)
        guard let url else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private static func locate(_ name: String, bundle: Bundle) -> URL? {
        if let nested = bundle.url(
            forResource: name,
            withExtension: "png",
            subdirectory: IllustrationCatalog.directoryName
        ) {
            return nested
        }
        return bundle.url(forResource: name, withExtension: "png")
    }
}

struct IllustrationImage: View {
    let pinyin: String

    var body: some View {
        if let uiImage = IllustrationStore.image(for: pinyin) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Theme.paperLight
        }
    }
}
