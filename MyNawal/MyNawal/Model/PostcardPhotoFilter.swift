import CoreImage
import UIKit

@MainActor
enum PostcardPhotoFilter {
    private static let context = CIContext()
    private static let cache: NSCache<UIImage, UIImage> = {
        let cache = NSCache<UIImage, UIImage>()
        cache.countLimit = 3
        cache.totalCostLimit = 64 * 1024 * 1024
        return cache
    }()

    static func monochrome(_ image: UIImage) -> UIImage {
        if let cached = cache.object(forKey: image) { return cached }
        // CIImage(image:) can ignore UIImage's orientation metadata. Apply it to the
        // pixels before producing an upright bitmap for the postcard.
        guard let source = image.cgImage.map({ CIImage(cgImage: $0) }) ?? image.ciImage else { return image }
        let input = source.oriented(forExifOrientation: image.imageOrientation.exifOrientation)
        let output = input.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0])
        guard let bitmap = context.createCGImage(output, from: output.extent) else { return image }
        let result = UIImage(cgImage: bitmap, scale: image.scale, orientation: .up)
        cache.setObject(result, forKey: image, cost: bitmap.bytesPerRow * bitmap.height)
        return result
    }
}

private extension UIImage.Orientation {
    var exifOrientation: Int32 {
        switch self {
        case .up: 1
        case .upMirrored: 2
        case .down: 3
        case .downMirrored: 4
        case .leftMirrored: 5
        case .right: 6
        case .rightMirrored: 7
        case .left: 8
        @unknown default: 1
        }
    }
}
