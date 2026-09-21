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
        guard let input = CIImage(image: image, options: [.applyOrientationProperty: true]) else { return image }
        let output = input.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0])
        guard let bitmap = context.createCGImage(output, from: output.extent) else { return image }
        let result = UIImage(cgImage: bitmap, scale: image.scale, orientation: .up)
        cache.setObject(result, forKey: image, cost: bitmap.bytesPerRow * bitmap.height)
        return result
    }
}
