import XCTest
import UIKit
@testable import MyNawal

@MainActor
final class PostcardPhotoTests: XCTestCase {
    func testCropAlwaysCoversViewportAndScalesForExport() {
        for image in [CGSize(width: 1200, height: 1800), CGSize(width: 1800, height: 900)] {
            for zoom in [0.5, 1, 2, 3, 5] {
                for offset in [-2.0, -1, 0, 1, 2] {
                    let settings = PostcardPhotoSettings(zoom: zoom, x: offset, y: offset)
                    let viewport = CGSize(width: 324, height: 205)
                    let crop = settings.geometry(image: image, viewport: viewport)
                    XCTAssertGreaterThanOrEqual(crop.size.width + 0.001, viewport.width)
                    XCTAssertGreaterThanOrEqual(crop.size.height + 0.001, viewport.height)
                    XCTAssertLessThanOrEqual(abs(crop.offset.width), (crop.size.width - viewport.width) / 2 + 0.001)
                    XCTAssertLessThanOrEqual(abs(crop.offset.height), (crop.size.height - viewport.height) / 2 + 0.001)
                    let export = settings.geometry(image: image, viewport: CGSize(width: 972, height: 615))
                    XCTAssertEqual(export.offset.width, crop.offset.width * 3, accuracy: 0.001)
                    XCTAssertEqual(export.offset.height, crop.offset.height * 3, accuracy: 0.001)
                }
            }
        }
    }

    func testPhotoShapesAndFinishesExportDistinctImages() throws {
        let image = try XCTUnwrap(UIImage(named: "SelfieDemo"))
        let draft = NawalPostcardDraft(result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
                                       birthDateText: "13 de marzo de 2005")
        var exports = Set<Data>()
        for shape in PostcardPhotoShape.allCases {
            for finish in PostcardPhotoFinish.allCases {
                var appearance = PostcardAppearance()
                appearance.photo = PostcardPhotoSettings(zoom: 1.4, x: 0.4, y: -0.3, shape: shape, finish: finish)
                let output = try PostcardExportService.render(draft: draft, selfieImage: image, appearance: appearance)
                XCTAssertTrue(exports.insert(output.pngData).inserted)
                XCTAssertEqual(output.image.size, PostcardExportService.exportSize)
                let attachment = XCTAttachment(image: output.image)
                attachment.name = "photo-\(shape.rawValue)-\(finish.rawValue)"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    func testResetPhotoPreservesOtherCustomization() {
        var appearance = PostcardAppearance(design: .woven, thickness: .bold)
        appearance.apply(.clay)
        let original = appearance
        appearance.photo = PostcardPhotoSettings(zoom: 3, x: 1, y: -1, shape: .circle, finish: .warm)
        appearance.photo = PostcardPhotoSettings()
        XCTAssertEqual(appearance, original)
    }
}
