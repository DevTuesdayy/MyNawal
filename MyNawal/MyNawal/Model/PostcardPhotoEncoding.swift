import UIKit

nonisolated enum PostcardPhotoEncoding {
    /// Store orientation in the pixels, including mirrored selfies. PNG consumers
    /// must see the same image even if they do not interpret orientation metadata.
    static func pngData(_ image: UIImage) -> Data? {
        guard image.size.width > 0, image.size.height > 0 else { return nil }
        if image.imageOrientation == .up { return image.pngData() }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.pngData { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
}
