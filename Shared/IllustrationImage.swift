import ImageIO
import SwiftUI
import UIKit
import JieqiCore

enum IllustrationStore {
    static func dedicatedURL(for pinyin: String, bundle: Bundle = .main) -> URL? {
        locate(
            IllustrationCatalog.resourceStem(for: pinyin),
            ext: IllustrationCatalog.imageExtension,
            bundle: bundle
        )
    }

    static func hasDedicatedImage(_ pinyin: String, bundle: Bundle = .main) -> Bool {
        dedicatedURL(for: pinyin, bundle: bundle) != nil
    }

    static func image(for pinyin: String, bundle: Bundle = .main, maxPixelSize: CGFloat? = nil) -> UIImage? {
        let url = dedicatedURL(for: pinyin, bundle: bundle)
            ?? locate(IllustrationCatalog.placeholder, ext: "png", bundle: bundle)
        guard let url else { return nil }
        if let maxPixelSize, let scaled = downsampledImage(at: url, maxPixelSize: maxPixelSize) {
            return scaled
        }
        return UIImage(contentsOfFile: url.path)
    }

    private static func locate(_ name: String, ext: String, bundle: Bundle) -> URL? {
        if let nested = bundle.url(
            forResource: name,
            withExtension: ext,
            subdirectory: IllustrationCatalog.directoryName
        ) {
            return nested
        }
        return bundle.url(forResource: name, withExtension: ext)
    }

    /// 解码时限制长边，避免小组件把整张 768×1280 的图展开进内存。
    private static func downsampledImage(at url: URL, maxPixelSize: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { return nil }
        let thumbnailOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxPixelSize.rounded(.up)),
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

struct IllustrationImage: View {
    let pinyin: String
    var maxPixelSize: CGFloat?

    init(pinyin: String, maxPixelSize: CGFloat? = nil) {
        self.pinyin = pinyin
        self.maxPixelSize = maxPixelSize
    }

    var body: some View {
        if let uiImage = IllustrationStore.image(for: pinyin, maxPixelSize: maxPixelSize) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Theme.paperLight
        }
    }
}
