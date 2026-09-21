import Foundation

nonisolated struct PostcardPhotoSettings: Equatable, Sendable {
    var zoom: Double = 1
    // Fractions of available overflow, so framing is independent of export resolution.
    var x: Double = 0
    var y: Double = 0
    var shape: PostcardPhotoShape = .rounded
    var finish: PostcardPhotoFinish = .natural

    func geometry(image: CGSize, viewport: CGSize) -> (size: CGSize, offset: CGSize) {
        let scale = max(viewport.width / max(image.width, 1), viewport.height / max(image.height, 1))
            * min(max(zoom, 1), 3)
        let size = CGSize(width: image.width * scale, height: image.height * scale)
        return (size, CGSize(
            width: max(0, (size.width - viewport.width) / 2) * min(max(x, -1), 1),
            height: max(0, (size.height - viewport.height) / 2) * min(max(y, -1), 1)
        ))
    }
}

nonisolated enum PostcardPhotoShape: String, CaseIterable, Identifiable, Sendable {
    case rounded, circle, oval
    var id: Self { self }
    var title: String {
        switch self {
        case .rounded: "Rectangular"
        case .circle: "Circular"
        case .oval: "Ovalado"
        }
    }
}

nonisolated enum PostcardPhotoFinish: String, CaseIterable, Identifiable, Sendable {
    case natural, warm, monochrome
    var id: Self { self }
    var title: String {
        switch self {
        case .natural: "Natural"
        case .warm: "Cálido"
        case .monochrome: "Blanco y negro"
        }
    }
}
