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

    private func makeModel() -> PaletteStudyViewModel {
        PaletteStudyViewModel(useCase: DefaultPaletteStudyUseCase(repository: MockPaletteStudyRepository()))
    }
}
