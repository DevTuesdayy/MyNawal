import XCTest
import UIKit
@testable import MyNawal

@MainActor
final class PostcardTextTests: XCTestCase {
    func testCustomizedTextExportsWithOptionalData() throws {
        let image = try XCTUnwrap(UIImage(named: "SelfieDemo"))
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "13 de marzo de 2005"
        )
        var appearance = PostcardAppearance(design: .woven, thickness: .medium)
        appearance.text = PostcardTextSettings(
            personName: "Alan Cervantes",
            message: "Mi historia camina conmigo y honra la memoria de mi comunidad.",
            typography: .classic,
            showsDate: true,
            showsAnimal: true,
            showsElement: true,
            showsEnergyAssociations: true
        )

        let detailed = try PostcardExportService.render(
            draft: draft,
            selfieImage: image,
            appearance: appearance
        )
        XCTAssertEqual(detailed.image.size, PostcardExportService.exportSize)

        appearance.text.typography = .clean
        appearance.text.showsDate = false
        appearance.text.showsAnimal = false
        appearance.text.showsElement = false
        appearance.text.showsEnergyAssociations = false
        let compact = try PostcardExportService.render(
            draft: draft,
            selfieImage: image,
            appearance: appearance
        )
        XCTAssertNotEqual(detailed.pngData, compact.pngData)

        let attachment = XCTAttachment(image: detailed.image)
        attachment.name = "postal-texto-personalizado"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testTextLimitsAndDefaultMessage() {
        let settings = PostcardTextSettings(
            personName: String(repeating: "A", count: 40),
            message: String(repeating: "B", count: 80)
        )
        XCTAssertEqual(settings.trimmedName.count, PostcardTextSettings.nameLimit)
        XCTAssertEqual(settings.resolvedMessage.count, PostcardTextSettings.messageLimit)
        XCTAssertEqual(PostcardTextSettings().resolvedMessage,
                       "Conecta con tu esencia  •  Honra tu origen")
    }
}
