import UIKit
import XCTest
@testable import MyNawal

@MainActor
final class AppReadinessTests: XCTestCase {
    func testCatalogContainsTwentyUniqueNawalesWithImages() {
        let nawales = NawalCatalogo.items

        XCTAssertEqual(nawales.count, 20)
        XCTAssertEqual(Set(nawales.map(\.nombre)).count, 20)

        for nawal in nawales {
            XCTAssertNotNil(
                UIImage(named: nawal.nombreImagen),
                "Falta la imagen local de \(nawal.nombre): \(nawal.nombreImagen)"
            )
        }
    }
}
