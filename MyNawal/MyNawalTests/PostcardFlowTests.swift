import SwiftUI
import UIKit
import XCTest
@testable import MyNawal

@MainActor
final class PostcardFlowTests: XCTestCase {
    func testPostcardRequiresSuccessfulCalculation() {
        let model = makeModel()
        model.createPostcard()
        XCTAssertNil(model.postcardDraft)
        XCTAssertEqual(model.selectedTab, .catalog)
    }

    func testPostcardKeepsChosenResultUntilExplicitlyReplaced() throws {
        let model = makeModel()
        let calendar = Calendar.current
        let firstDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2005, month: 3, day: 13)))
        let secondDate = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: firstDate))
        model.calculateNawal(for: firstDate)
        model.createPostcard()
        let original = try XCTUnwrap(model.postcardDraft)
        XCTAssertEqual(original.result, model.calculationResult)
        XCTAssertEqual(original.birthDateText, firstDate.formatted(
            .dateTime.day().month(.wide).year().locale(Locale(identifier: "es_MX"))
        ))
        XCTAssertEqual(model.selectedTab, .postcard)

        model.selectTab(.calculator)
        model.calculateNawal(for: secondDate)
        XCTAssertEqual(model.postcardDraft, original)
        model.createPostcard()
        XCTAssertNotEqual(model.postcardDraft, original)
        XCTAssertEqual(model.postcardDraft?.result, model.calculationResult)
        XCTAssertEqual(model.postcardDraft?.birthDateText, secondDate.formatted(
            .dateTime.day().month(.wide).year().locale(Locale(identifier: "es_MX"))
        ))
        XCTAssertEqual(model.selectedTab, .postcard)
    }

    func testCompletedPostcardCanRenderAsImage() throws {
        let nawal = try XCTUnwrap(NawalCatalogo.items.first)
        let selfie = try XCTUnwrap(UIImage(systemName: "person.crop.square"))
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: nawal, energia: 11),
            birthDateText: "10 de diciembre de 1954"
        )
        let postcard = NawalPostcardCanvas(draft: draft, selfieImage: selfie)
            .frame(width: 360, height: 450)

        let renderer = ImageRenderer(content: postcard)
        renderer.scale = 1

        let renderedImage = try XCTUnwrap(renderer.uiImage)
        XCTAssertEqual(renderedImage.size.width, 360, accuracy: 0.5)
        XCTAssertEqual(renderedImage.size.height, 450, accuracy: 0.5)
    }

    func testPostcardExporterCreatesHighResolutionPNG() throws {
        let nawal = try XCTUnwrap(NawalCatalogo.items.first)
        let selfie = try XCTUnwrap(UIImage(systemName: "person.crop.square"))
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: nawal, energia: 11),
            birthDateText: "10 de diciembre de 1954"
        )

        let export = try PostcardExportService.render(draft: draft, selfieImage: selfie)

        XCTAssertEqual(export.image.size.width, 1080, accuracy: 0.5)
        XCTAssertEqual(export.image.size.height, 1350, accuracy: 0.5)
        XCTAssertFalse(export.pngData.isEmpty)
    }

    func testAllDesignAndFrameCombinationsExportDistinctImages() throws {
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        )
        let selfie = try XCTUnwrap(UIImage(named: "SelfieDemo") ?? UIImage(systemName: "person.crop.square"))
        var exports = Set<Data>()
        for design in PostcardDesign.allCases {
            for thickness in PostcardFrameThickness.allCases {
                let export = try PostcardExportService.render(
                    draft: draft, selfieImage: selfie,
                    appearance: PostcardAppearance(design: design, thickness: thickness)
                )
                let decoded = try XCTUnwrap(UIImage(data: export.pngData))
                XCTAssertEqual(decoded.size, PostcardExportService.exportSize)
                XCTAssertTrue(exports.insert(export.pngData).inserted,
                              "Duplicate appearance: \(design) / \(thickness)")
                let attachment = XCTAttachment(image: decoded)
                attachment.name = "\(design.rawValue)-\(thickness.rawValue)"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    func testColorPalettesExportAndPreserveFrameSelection() throws {
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        )
        let selfie = try XCTUnwrap(UIImage(systemName: "person.crop.square"))
        var appearance = PostcardAppearance(design: .woven, thickness: .bold)
        var images = Set<Data>()
        for palette in PostcardPalette.allCases {
            appearance.apply(palette)
            XCTAssertEqual(appearance.design, .woven)
            XCTAssertEqual(appearance.thickness, .bold)
            let export = try PostcardExportService.render(draft: draft, selfieImage: selfie, appearance: appearance)
            XCTAssertTrue(images.insert(export.pngData).inserted)
            XCTAssertEqual(export.image.size, PostcardExportService.exportSize)
        }
        let before = try PostcardExportService.render(draft: draft, selfieImage: selfie, appearance: appearance)
        appearance.frameColor = .red
        appearance.accentColor = .jade
        let after = try PostcardExportService.render(draft: draft, selfieImage: selfie, appearance: appearance)
        XCTAssertNotEqual(before.pngData, after.pngData)
        XCTAssertEqual(appearance.background, .ivory)
    }

#if targetEnvironment(simulator)
    func testSimulatorDemoSelfieIsBundled() throws {
        let demoImage = try XCTUnwrap(UIImage(named: "SelfieDemo"))
        XCTAssertGreaterThan(demoImage.size.width, 0)
        XCTAssertGreaterThan(demoImage.size.height, 0)
    }
#endif

    private func makeModel() -> PaletteStudyViewModel {
        PaletteStudyViewModel(useCase: DefaultPaletteStudyUseCase(repository: MockPaletteStudyRepository()))
    }
}
